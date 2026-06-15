import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceData>>> getAttendanceMe({
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<AttendanceModel>>> getAllAttendance({
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<AttendanceData>>> getAttendanceById(
    String id, {
    bool forceRefresh = false,
  });
  Future<Either<Failure, String>> generateAttendance();
  Future<Either<Failure, void>> checkInAt(String data);
  Future<Either<Failure, void>> checkOutAt(String data);
}
