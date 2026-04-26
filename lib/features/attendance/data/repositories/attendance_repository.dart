import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceModel>>> getAllAttendances();
  Future<Either<Failure, AttendanceModel>> getAttendanceByUid(String uid);
  Future<Either<Failure, AttendanceModel>> createAttendance(
      AttendanceModel attendance);
  Future<Either<Failure, void>> deleteAttendance(String uid);
}