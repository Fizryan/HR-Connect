import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';

abstract class BaseRepository {
  final logger = LoggerConfig.logger;

  Future<Either<Failure, T>> sourceCall<T>(
    Future<T> Function() call,
    String fallbackErrorMessage,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      logger.e('[$runtimeType] Error', error: e, stackTrace: stackTrace);
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }
}
