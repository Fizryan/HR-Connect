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

  @override
  Future<Either<Failure, List<LeaveRequestModel>>> getLeaveRequests() async {
    try {
      final leaveRequests = await remoteDataSource.getLeaveRequests();
      return Right(leaveRequests);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, LeaveRequestModel>> getLeaveRequestById(
    String id,
  ) async {
    try {
      final leaveRequest = await remoteDataSource.getLeaveRequestsById(id);
      return Right(leaveRequest);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      debugPrint('[LeaveRepository] Get Leave Request By ID Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to load leave request data. Please try again.',
            name: 'loadLeaveRequestDataFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, LeaveRequestModel>> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final updateLeaveRequest = await remoteDataSource.updateLeaveRequest(
        id,
        updateData,
      );
      return Right(updateLeaveRequest);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[LeaveRepository] Update Leave Request Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to update leave request data. Please check again.',
            name: 'updateLeaveRequestDataFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteLeaveRequest(String id) async {
    try {
      await remoteDataSource.deleteLeaveRequest(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[LeaveRepository] Delete Leave Request Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to delete leave request. Please try again.',
            name: 'deleteLeaveRequestFailed',
          ),
        ),
      );
    }
  }
}
