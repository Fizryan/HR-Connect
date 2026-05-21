import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/dashboard/data/datasource/dashboard_remote.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';
import 'package:hr_connect/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:intl/intl.dart';

class DashboardRepositoryImp implements DashboardRepository {
  final DashboardRemote remoteDataSource;

  DashboardRepositoryImp({required this.remoteDataSource});

  Future<Either<Failure, T>> _sourceCall<T>(
    Future<T> Function() call,
    String fallbackErrorMessage,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[DashboardRepository] Error: $e');
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }

  @override
  Future<Either<Failure, DashboardModel>> getDashboard() async {
    return _sourceCall(
      remoteDataSource.getDashboard,
      Intl.message(
        'Failed to load dashboard data. Please try again.',
        name: 'loadDashboardDataFailed',
      ),
    );
  }
}
