import 'package:flutter/rendering.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/datasource/leave_request_remote.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';
import 'package:hr_connect/features/leave/data/repositories/leave_repository.dart';
import 'package:intl/intl.dart';

class LeaveRepositoryImp implements LeaveRepository {
  final LeaveRequestRemote remoteDataSource;

  LeaveRepositoryImp({required this.remoteDataSource});

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
      debugPrint('[LeaveRepository] Error: $e');
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequestModel>>> getLeaveRequests() async {
    return _sourceCall(
      remoteDataSource.getLeaveRequests,
      Intl.message(
        'Failed to load leave requests data. Please try again.',
        name: 'loadLeaveRequestDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, LeaveRequestModel>> getLeaveRequestById(
    String id,
  ) async {
    return _sourceCall(
      () => remoteDataSource.getLeaveRequestsById(id),
      Intl.message(
        'Failed to load leave request data. Please try again.',
        name: 'loadLeaveRequestDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, LeaveRequestModel>> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _sourceCall(
      () => remoteDataSource.updateLeaveRequest(id, updateData),
      Intl.message(
        'Failed to update leave request. Please try again.',
        name: 'updateLeaveRequestFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteLeaveRequest(String id) async {
    return _sourceCall(
      () => remoteDataSource.deleteLeaveRequest(id),
      Intl.message(
        'Failed to delete leave request. Please try again.',
        name: 'deleteLeaveRequestFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> approveLeaveRequest(String id) async {
    return _sourceCall(
      () => remoteDataSource.approveLeaveRequest(id),
      Intl.message(
        'Failed to approve leave request. Please try again.',
        name: 'approveLeaveRequestFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> rejectLeaveRequest(String id) async {
    return _sourceCall(
      () => remoteDataSource.rejectLeaveRequest(id),
      Intl.message(
        'Failed to reject leave request. Please try again.',
        name: 'rejectLeaveRequestFailed',
      ),
    );
  }
}
