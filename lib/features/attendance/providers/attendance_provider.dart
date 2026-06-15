import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';
import 'package:hr_connect/features/attendance/providers/base_attendance_provider.dart';

final attendanceMeProvider =
    AsyncNotifierProvider<AttendanceMeNotifier, List<AttendanceData>>(
      AttendanceMeNotifier.new,
    );

class AttendanceMeNotifier
    extends BaseSharedAttendanceProvider<AttendanceData> {
  @override
  Future<Either<Failure, List<AttendanceData>>> fetchFromRepository() {
    return ref.read(attendanceRepositoryProvider).getAttendanceMe();
  }
}

final attendanceNotifierProvider =
    AsyncNotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      AttendanceNotifier.new,
    );

class AttendanceNotifier extends BaseSharedAttendanceProvider<AttendanceModel> {
  @override
  Future<Either<Failure, List<AttendanceModel>>> fetchFromRepository() {
    return ref.read(attendanceRepositoryProvider).getAllAttendance();
  }
}

final attendanceQrNotifier =
    AsyncNotifierProvider<AttendanceQrNotifier, String?>(
      AttendanceQrNotifier.new,
    );

class AttendanceQrNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> generateQrCode() async {
    state = const AsyncValue.loading();

    final repository = ref.read(attendanceRepositoryProvider);
    final result = await repository.generateAttendance();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      AsyncValue.data,
    );
  }
}
