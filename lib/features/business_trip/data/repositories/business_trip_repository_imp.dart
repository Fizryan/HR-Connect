import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/business_trip/data/datasource/business_trip_remote.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';
import 'package:hr_connect/features/business_trip/data/repositories/business_trip_repository.dart';
import 'package:intl/intl.dart';

class BusinessTripRepositoryImp implements BusinessTripRepository {
  final BusinessTripRemote remoteDataSource;

  BusinessTripRepositoryImp({required this.remoteDataSource});

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
      debugPrint('[BusinessTripRepository] Error: $e');
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<BusinessTripModel>>> getBusinessTrip() async {
    return _sourceCall(
      remoteDataSource.getBusinessTrip,
      Intl.message(
        'Failed to load business trip data. Please try again.',
        name: 'loadBusinessTripDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, BusinessTripModel>> getBusinessTripById(
    String id,
  ) async {
    return _sourceCall(
      () => remoteDataSource.getBusinessTripById(id),
      Intl.message(
        'Failed to load business trip data. Please try again.',
        name: 'loadBusinessTripDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, BusinessTripModel>> updateBusinessTrip(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _sourceCall(
      () => remoteDataSource.updateBusinessTrip(id, updateData),
      Intl.message(
        'Failed to update business trip. Please try again.',
        name: 'updateBusinessTripFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteBusinessTrip(String id) async {
    return _sourceCall(
      () => remoteDataSource.deleteBusinessTrip(id),
      Intl.message(
        'Failed to delete business trip. Please try again.',
        name: 'deleteBusinessTripFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> approveBusinessTrip(String id) async {
    return _sourceCall(
      () => remoteDataSource.approveBusinessTrip(id),
      Intl.message(
        'Failed to approve business trip. Please try again.',
        name: 'approveBusinessTripFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> rejectBusinessTrip(String id) async {
    return _sourceCall(
      () => remoteDataSource.rejectBusinessTrip(id),
      Intl.message(
        'Failed to reject business trip. Please try again.',
        name: 'rejectBusinessTripFailed',
      ),
    );
  }
}
