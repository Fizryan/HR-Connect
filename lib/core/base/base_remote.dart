import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/error/exception.dart';

abstract class BaseRemote {
  final _logger = LoggerConfig.logger;

  Future<T> apiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Fatal error in remote layer',
        error: e,
        stackTrace: stackTrace,
      );
      throw ServerException(message: 'Something went wrong.');
    }
  }
}
