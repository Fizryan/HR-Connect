import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance/providers/attendance_provider.dart';

abstract class BaseSharedAttendanceProvider<T> extends BaseListNotifier<T> {
  DateTime? lastFetchTime;

  Future<Either<Failure, List<T>>> fetchFromRepository();

  @override
  FutureOr<List<T>> build() async {
    final data = await _fetchLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<T>> _fetchLogic() async {
    final result = await fetchFromRepository();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (attendance) => attendance,
    );
  }

  Future<void> fetchAttendance() async {
    if (state.isLoading) return;
    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 10;

    if (isCacheValid && state.hasValue) return;

    await refreshAttendance();
  }

  Future<void> refreshAttendance() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchLogic);

    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<Either<Failure, void>> checkInAt(String data) async {
    final repository = ref.read(attendanceRepositoryProvider);
    return handleMutation(
      action: () => repository.checkInAt(data),
      onSuccess: (_) {
        ref.invalidate(attendanceMeProvider);
        ref.invalidate(attendanceNotifierProvider);
      },
    );
  }

  Future<Either<Failure, void>> checkOutAt(String data) async {
    final repository = ref.read(attendanceRepositoryProvider);
    return handleMutation(
      action: () => repository.checkOutAt(data),
      onSuccess: (_) {
        ref.invalidate(attendanceMeProvider);
        ref.invalidate(attendanceNotifierProvider);
      },
    );
  }
}
