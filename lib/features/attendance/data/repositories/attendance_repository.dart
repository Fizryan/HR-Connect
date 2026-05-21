import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<UserAttendanceModel>>> getAttendance();
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceMe();
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceById(String id);
  Future<Either<Failure, void>> checkIn(String payload);
  Future<Either<Failure, void>> checkOut(String payload);
  Future<Either<Failure, AttendanceGenerateModel>> generateAttendance();
  Future<Either<Failure, AttendanceGenerateModel>> todayAttendance();
}
