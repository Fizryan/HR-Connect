import 'package:dio/dio.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/core/error/core_exception.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final FlutterSecureStorage secureStorage;

  String? _cachedToken;

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
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _cachedToken ??= await secureStorage.read(key: 'auth_token');
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
            _cachedToken = null;

            final refreshToken = await secureStorage.read(key: 'refresh_token');
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final dio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
                final response = await dio.post(
                  '/auth/refresh',
                  data: {'refreshToken': refreshToken},
                );

                final newToken = response.data['token'];
                if (newToken != null) {
                  updateToken(newToken);
                  await secureStorage.write(key: 'auth_token', value: newToken);

                  final options = e.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';

                  final retryResponse = await _dio.fetch(options);
                  return handler.resolve(retryResponse);
                }
              } catch (refreshError) {
                _cachedToken = null;
                await secureStorage.delete(key: 'auth_token');
                await secureStorage.delete(
                  key: 'refresh_token',
                );
                sl<AuthProvider>().logout();
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
      CoreException.handleDioException(e);
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
      CoreException.handleDioException(e);
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
      CoreException.handleDioException(e);
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
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      CoreException.handleDioException(e);
    }
  }
}
