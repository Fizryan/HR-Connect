import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/attendance/data/datasource/attendance_remote.dart';
import 'package:hr_connect/features/logic/attendance/data/models/attendance_model.dart';
import 'package:hr_connect/features/logic/attendance/data/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AttendanceModel>>> getAllAttendances() async {
    try {
      final result = await remoteDataSource.getAllAttendances();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceModel>> getAttendanceByUid(
    String uid,
  ) async {
    try {
      final result = await remoteDataSource.getAttendanceByUid(uid);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceModel>> createAttendance(
    AttendanceModel attendance,
  ) async {
    try {
      final result = await remoteDataSource.createAttendance(
        attendance.toJson(),
      );
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendance(String uid) async {
    try {
      await remoteDataSource.deleteAttendance(uid);
      return const Right(null);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }
}
