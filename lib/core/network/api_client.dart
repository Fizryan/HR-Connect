import 'package:dio/dio.dart';
import 'package:hr_connect/core/const/secure_storage.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final FlutterSecureStorage secureStorage;

  String? _cachedToken;
  bool _isRefreshing = false;

  ApiClient({required this.secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? 'https://example.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          _cachedToken ??= await secureStorage.read(
            key: SecureStorage.accessToken,
          );

          if (_cachedToken != null && _cachedToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }

          _logger.i('REQUEST [${options.method}] => PATH: ${options.path}');
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

            if (!_isRefreshing) {
              _isRefreshing = true;

              final refreshToken = await secureStorage.read(
                key: SecureStorage.refreshToken,
              );

              if (refreshToken != null && refreshToken.isNotEmpty) {
                try {
                  final refreshDio = Dio(
                    BaseOptions(baseUrl: _dio.options.baseUrl),
                  );

                  final response = await refreshDio.post(
                    'v1/auth/refresh',
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

                    final options = e.requestOptions;
                    options.headers['Authorization'] = 'Bearer $newAccessToken';

                    _isRefreshing = false;

                    final retryResponse = await _dio.fetch(options);
                    return handler.resolve(retryResponse);
                  }
                } catch (refreshError) {
                  _logger.e('Failed to refresh token: $refreshError');
                  _isRefreshing = false;
                  clearToken();
                  await secureStorage.deleteAll();
                  return handler.reject(e);
                }
              } else {
                _isRefreshing = false;
              }
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

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw CoreException.handleDioException(e);
    }
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw CoreException.handleDioException(e);
    }
  }

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw CoreException.handleDioException(e);
    }
  }

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw CoreException.handleDioException(e);
    }
  }
}
