import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Logger logger;

  RetryInterceptor({required this.dio, required this.logger});

  static const maxRetries = 3;

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.response?.statusCode == 502 ||
        e.response?.statusCode == 503 ||
        e.response?.statusCode == 504;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;

    if (!_shouldRetry(err) || retryCount >= maxRetries) {
      return handler.next(err);
    }

    final delay = Duration(milliseconds: 500 * (1 << retryCount));

    logger.w('Retry ${retryCount + 1} after ${delay.inMilliseconds}ms');

    await Future.delayed(delay);

    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await dio.fetch(err.requestOptions);

      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}
