import 'dart:async';
import 'package:dio/dio.dart';
import 'package:hr_connect/core/config/env_config.dart';
import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/const/secure_storage.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/rate_limit_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final FlutterSecureStorage secureStorage;

  String? _cachedToken;
  final Map<String, Future<dynamic>> _inFlightRequests = {};

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

    _dio.interceptors.add(RateLimitInterceptor());
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

                final newAccessToken = response.data['accessToken'];
                final newRefreshToken = response.data['refreshToken'];

                if (newAccessToken != null) {
                  updateToken(newAccessToken);
                  await secureStorage.write(
                    key: SecureStorage.accessToken,
                    value: newAccessToken,
                  );

                  if (newRefreshToken != null) {
                    await secureStorage.write(
                      key: SecureStorage.refreshToken,
                      value: newRefreshToken,
                    );
                  }

                  final retryOptions = e.requestOptions;
                  retryOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final retryResponse = await _dio.fetch(retryOptions);
                  return handler.resolve(retryResponse);
                } else {
                  _logger.e('Failed to retrieve new access token');
                  clearToken();
                  await secureStorage.deleteAll();
                  return handler.reject(e);
                }
              } catch (refreshError) {
                _logger.e('Failed to refresh token: $refreshError');
                clearToken();
                await secureStorage.deleteAll();
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
  }

  void clearToken() {
    _cachedToken = null;
  }

  Future<dynamic> _handleRequest(
    String method,
    String path,
    Future<Response> Function() requestAction, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final requestKey = '$method:$path:${queryParameters?.toString() ?? ''}:${data?.toString() ?? ''}';

    if (_inFlightRequests.containsKey(requestKey)) {
      _logger.i('Deduplicating $method request (in-flight): $requestKey');
      return await _inFlightRequests[requestKey];
    }

    final completer = Completer<dynamic>();
    _inFlightRequests[requestKey] = completer.future;

    try {
      final response = await requestAction();
      completer.complete(response.data);
      _inFlightRequests.remove(requestKey);
      return response.data;
    } catch (e, st) {
      Exception mappedException = e is Exception ? e : Exception(e.toString());
      if (e is DioException) {
        mappedException = CoreException.handleDioException(e);
      }

      if (!completer.isCompleted) {
        completer.completeError(mappedException, st);
      }

      _inFlightRequests.remove(requestKey);
      throw mappedException;
    }
  }

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
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
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
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
  }

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
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
  }

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(
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
  }
}
