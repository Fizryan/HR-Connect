import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/datasource/attendance_remote.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';
import 'package:hr_connect/features/attendance/data/repositories/attendance_repository.dart';
import 'package:intl/intl.dart';

class AttendanceRepositoryImp implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;

  AttendanceRepositoryImp({required this.remoteDataSource});

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
      debugPrint('[AttendanceRepository] Error: $e');
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<UserAttendanceModel>>> getAttendance() async {
    return _sourceCall(
      remoteDataSource.getAttendance,
      Intl.message('Failed to load attendance.', name: 'loadAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceMe() async {
    return _sourceCall(
      remoteDataSource.getAttendanceMe,
      Intl.message('Failed to load your attendance.', name: 'loadMyAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceById(String id) async {
    return _sourceCall(
      () => remoteDataSource.getAttendanceById(id),
      Intl.message('Failed to load user attendance.', name: 'loadUserAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> checkIn(String payload) async {
    return _sourceCall(
      () => remoteDataSource.checkIn(payload),
      Intl.message('Check-in failed.', name: 'checkInFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> checkOut(String payload) async {
    return _sourceCall(
      () => remoteDataSource.checkOut(payload),
      Intl.message('Check-out failed.', name: 'checkOutFailed'),
    );
  }

  @override
  Future<Either<Failure, AttendanceGenerateModel>> generateAttendance() async {
    return _sourceCall(
      remoteDataSource.generateAttendance,
      Intl.message('Failed to generate attendance QR.', name: 'generateAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, AttendanceGenerateModel>> todayAttendance() async {
    return _sourceCall(
      remoteDataSource.todayAttendance,
      Intl.message('Failed to load today QR.', name: 'loadTodayQrFailed'),
    );
  }
}
