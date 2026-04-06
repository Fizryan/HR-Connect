import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final FlutterSecureStorage secureStorage;

  ApiClient({required this.secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? 'https://example.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      )
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          _logger.i('REQUEST [${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },

        onResponse: (response, handler) {
          _logger.i('RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },

        onError: (DioException e, handler) {
          _logger.e('ERROR [${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      )
    );
  }

  Dio get dio => _dio;
}
