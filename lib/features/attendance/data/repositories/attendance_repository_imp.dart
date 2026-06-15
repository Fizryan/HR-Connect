import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';
import 'package:hr_connect/features/attendance/data/remote/attendance_remote.dart';
import 'package:hr_connect/features/attendance/data/repositories/attendance_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRepositoryImp extends BaseRepository
    implements AttendanceRepository {
  final AttendanceRemote remoteDataSource;
  final SharedPreferences sharedPreferences;

  AttendanceRepositoryImp({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<AttendanceData>>> getAttendanceMe({
    bool forceRefresh = false,
  }) async {
    final apiResult = await sourceCall(
      () async {
        final attendance = await remoteDataSource.getAttendanceMe(
          forceRefresh: forceRefresh,
        );
        final attendanceListJson = attendance
            .map((attendance) => attendance.toJson())
            .toList();

        await sharedPreferences.setString(
          SharedPrefs.cachedAttendance,
          jsonEncode(attendanceListJson),
        );

        return attendance;
      },
      Intl.message(
        'Failed to load attendance information.',
        name: 'loadAttendanceMeFailed',
      ),
    );

    return apiResult.fold(
      (failure) {
        logger.e('[AttendanceRepository] API call failed, loading from cache.');
        final cachedData = sharedPreferences.getString(
          SharedPrefs.cachedAttendance,
        );

        if (cachedData != null && cachedData.isNotEmpty) {
          final decodeAttendance = jsonDecode(cachedData) as List<dynamic>;
          final cachedAttendance = decodeAttendance
              .map(
                (attendance) =>
                    AttendanceData.fromJson(attendance as Map<String, dynamic>),
              )
              .toList();
          return Right(cachedAttendance);
        }

        return Left(failure);
      },
      (attendance) {
        return Right(attendance);
      },
    );
  }

  @override
  Future<Either<Failure, List<AttendanceModel>>> getAllAttendance({
    bool forceRefresh = false,
  }) async {
    return sourceCall(
      () async =>
          await remoteDataSource.getAllAttendance(forceRefresh: forceRefresh),
      Intl.message('Failed to load attendance.', name: 'loadAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, List<AttendanceData>>> getAttendanceById(
    String id, {
    bool forceRefresh = false,
  }) async {
    return sourceCall(
      () async => await remoteDataSource.getAttendanceById(
        id,
        forceRefresh: forceRefresh,
      ),
      Intl.message('Failed to load attendance.', name: 'loadAttendanceFailed'),
    );
  }

  @override
  Future<Either<Failure, String>> generateAttendance() async {
    return sourceCall(
      remoteDataSource.generateAttendance,
      Intl.message(
        'Failed to generate attendance.',
        name: 'generateAttendanceFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> checkInAt(String data) async {
    return sourceCall(
      () => remoteDataSource.checkInAt(data),
      Intl.message('Failed to check in.', name: 'checkInFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> checkOutAt(String data) async {
    return sourceCall(
      () => remoteDataSource.checkOutAt(data),
      Intl.message('Failed to check out.', name: 'checkOutFailed'),
    );
  }
}
