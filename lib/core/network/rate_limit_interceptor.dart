import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RateLimitInterceptor extends Interceptor {
  final Logger _logger = Logger();
  final Duration delay;
  final Map<String, DateTime> _lastRequestTimes = {};

  RateLimitInterceptor({this.delay = const Duration(milliseconds: 1000)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only apply rate limiting to POST, PUT, DELETE to prevent double submissions.
    // GET requests are typically safe and already deduplicated by _inFlightRequests.
    if (options.method == 'GET') {
      return super.onRequest(options, handler);
    }

    final requestKey = '${options.method}:${options.path}';
    final now = DateTime.now();

    if (_lastRequestTimes.containsKey(requestKey)) {
      final lastTime = _lastRequestTimes[requestKey]!;
      final difference = now.difference(lastTime);

      if (difference < delay) {
        _logger.w('RateLimitInterceptor: Blocked spam request to $requestKey');
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            error: 'Too many requests. Please wait a moment before trying again.',
          ),
        );
      }
    }

    _lastRequestTimes[requestKey] = now;
    super.onRequest(options, handler);
  }
}
