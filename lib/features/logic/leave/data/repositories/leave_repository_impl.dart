import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/leave/data/datasource/leave_remote.dart';
import 'package:hr_connect/features/logic/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/logic/leave/data/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemote remoteDataSource;

  LeaveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LeaveModel>>> getAllLeaves() async {
    try {
      final result = await remoteDataSource.getAllLeaves();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveModel>> getLeaveByUid(String uid) async {
    try {
      final result = await remoteDataSource.getLeaveByUid(uid);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveModel>> createLeave(LeaveModel leave) async {
    try {
      final result = await remoteDataSource.createLeave(leave.toJson());
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveModel>> updateLeave(LeaveModel leave) async {
    try {
      final result = await remoteDataSource.updateLeave(
        leave.uid,
        leave.toJson(),
      );
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLeave(String uid) async {
    try {
      await remoteDataSource.deleteLeave(uid);
      return const Right(null);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }
}
