import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_connect/core/config/env_config.dart';
import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/constants/secure_storage.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/circuit_breaker.dart';
import 'package:hr_connect/core/network/memory_cache.dart';
import 'package:hr_connect/core/network/retry_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final _logger = LoggerConfig.logger;
  final FlutterSecureStorage secureStorage;
  final CircuitBreaker _circuitBreaker = CircuitBreaker();
  final MemoryCache _cacheManager = MemoryCache();
  final Map<String, Future<dynamic>> _inFlightRequests = {};

  String? _cachedToken;
  Future<void>? _refreshTokenFuture;

  ApiClient({required this.secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(RetryInterceptor(dio: _dio, logger: _logger));

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          _cachedToken ??= await secureStorage.read(
            key: SecureStorage.accessToken,
          );

          if (_cachedToken != null && _cachedToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }

          _logger.i('REQUEST [${options.method}] => PATH: ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
            'RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            _logger.w('Token expired, attempting refresh...');

            if (_refreshTokenFuture != null) {
              _logger.i(
                'Waiting for in-flight refresh token request to complete...',
              );
              try {
                await _refreshTokenFuture;
                final retryOptions = e.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $_cachedToken';
                final retryResponse = await _dio.fetch(retryOptions);
                return handler.resolve(retryResponse);
              } catch (refreshError) {
                return handler.reject(e);
              }
            }

            final requestToken = e.requestOptions.headers['Authorization']
                ?.toString()
                .replaceAll('Bearer ', '');

            if (requestToken != null && requestToken != _cachedToken) {
              _logger.i('Token already refreshed, retrying request...');
              final retryOptions = e.requestOptions;
              retryOptions.headers['Authorization'] = 'Bearer $_cachedToken';
              final retryResponse = await _dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            }

            final refreshToken = await secureStorage.read(
              key: SecureStorage.refreshToken,
            );

            if (refreshToken != null && refreshToken.isNotEmpty) {
              final completer = Completer<void>();
              _refreshTokenFuture = completer.future;

              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: _dio.options.baseUrl,
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                  ),
                );

                final response = await refreshDio.post(
                  ApiEndpoints.authRefresh,
                  data: {'refreshToken': refreshToken},
                );

                final data = response.data as Map<String, dynamic>;
                final newAccessToken = data['accessToken'] as String?;
                final newRefreshToken = data['refreshToken'] as String?;

                if (newAccessToken != null && newAccessToken.isNotEmpty) {
                  updateToken(newAccessToken);
                  await secureStorage.write(
                    key: SecureStorage.accessToken,
                    value: newAccessToken,
                  );

                  if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
                    await secureStorage.write(
                      key: SecureStorage.refreshToken,
                      value: newRefreshToken,
                    );
                  }

                  completer.complete();
                  _refreshTokenFuture = null;

                  final retryOptions = e.requestOptions;
                  retryOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final retryResponse = await _dio.fetch(retryOptions);

                  return handler.resolve(retryResponse);
                } else {
                  _logger.e('Failed to retrieve new access token');
                  clearToken();
                  await secureStorage.deleteAll();
                  completer.completeError(
                    'Failed to retrieve new access token',
                  );
                  _refreshTokenFuture = null;
                  return handler.reject(e);
                }
              } catch (refreshError) {
                _logger.e('Failed to refresh token: $refreshError');
                clearToken();
                await secureStorage.deleteAll();
                completer.completeError(refreshError);
                _refreshTokenFuture = null;
                return handler.reject(e);
              }
            } else {
              _logger.e('Refresh token is empty or null');
              clearToken();
              await secureStorage.deleteAll();
              return handler.reject(e);
            }
          }
          _logger.e(
            'ERROR [${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          return handler.next(e);
        },
      ),
    );
  }

  void updateToken(String token) {
    _cachedToken = token;
    _logger.i('[ApiClient] Token cache has been updated.');
  }

  void clearToken() {
    _cachedToken = null;
    _logger.i('[ApiClient] Token cache has been completely cleared.');
  }

  void clearMemoryCache() {
    _cacheManager.clear();
    _logger.i('[ApiClient] Memory cache has been completely cleared.');
  }

  String _buildCacheKey(String path, Map<String, dynamic>? query) {
    final sorted = Map.fromEntries(
      (query ?? {}).entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$path:${jsonEncode(sorted)}';
  }

  String _buildRequestKey(
    String method,
    String path,
    Map<String, dynamic>? query,
  ) {
    return '$method:${_buildCacheKey(path, query)}';
  }

  Future<dynamic> _handleRequest(
    String method,
    String path,
    Future<Response> Function() requestAction, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!_circuitBreaker.canExecute()) {
      throw Exception(
        'Service temporarily unavailable. Circuit Breaker is open.',
      );
    }

    final requestKey = _buildRequestKey(method, path, queryParameters);

    if (_inFlightRequests.containsKey(requestKey)) {
      _logger.i('Deduplicating in-flight request for: $requestKey');
      return await _inFlightRequests[requestKey];
    }

    Future<dynamic> executeRequest() async {
      try {
        final response = await requestAction();
        _circuitBreaker.onSuccess();
        return response.data;
      } catch (e) {
        if (e is DioException) {
          final statusCode = e.response?.statusCode;

          final shouldTripBreaker =
              e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              statusCode == 500 ||
              statusCode == 502 ||
              statusCode == 503 ||
              statusCode == 504;

          if (shouldTripBreaker) {
            _circuitBreaker.onFailure();
          }
        }

        Exception mappedException = e is Exception
            ? e
            : Exception(e.toString());
        if (e is DioException) {
          mappedException = CoreException.handleDioException(e);
        }
        throw mappedException;
      }
    }

    final requestFuture = executeRequest();
    _inFlightRequests[requestKey] = requestFuture;

    try {
      return await requestFuture;
    } finally {
      _inFlightRequests.remove(requestKey);
    }
  }

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool forceRefresh = false,
  }) async {
    final cachedKey = _buildCacheKey(path, queryParameters);

    if (!forceRefresh) {
      final cachedData = _cacheManager.get(cachedKey);
      if (cachedData != null) {
        _logger.i('Cache hit for $cachedKey');
        return cachedData;
      }
    }

    final result = await _handleRequest(
      'GET',
      path,
      () => _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      data: data,
      queryParameters: queryParameters,
    );

    _cacheManager.set(cachedKey, result, const Duration(minutes: 5));
    return result;
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _handleRequest(
      'POST',
      path,
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      data: data,
      queryParameters: queryParameters,
    );

    _cacheManager.invalidateByPrefix(path);
    return result;
  }

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _handleRequest(
      'PUT',
      path,
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      data: data,
      queryParameters: queryParameters,
    );

    _cacheManager.clear();
    return result;
  }

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _handleRequest(
      'DELETE',
      path,
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      data: data,
      queryParameters: queryParameters,
    );
    _cacheManager.clear();
    return result;
  }
}
