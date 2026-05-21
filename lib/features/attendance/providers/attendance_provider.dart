import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';

final attendanceNotifierProvider =
    AsyncNotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      AttendanceNotifier.new,
    );

class AttendanceNotifier extends AsyncNotifier<List<AttendanceModel>> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<AttendanceModel>> build() async {
    return _fetchAttendanceLogic();
  }

  Future<List<AttendanceModel>> _fetchAttendanceLogic() async {
    final repository = ref.read(attendanceRepositoryProvider);
    final result = await repository.getAttendanceMe();

    return result.fold(
      (failure) => throw failure.message,
      (attendanceList) {
        lastFetchTime = DateTime.now();
        return attendanceList;
      },
    );
  }

  Future<void> fetchAttendance() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 5;

    if (isCacheValid && state.hasValue) {
      return;
    }

    await refreshAttendance();
  }

  Future<void> refreshAttendance() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchAttendanceLogic);
  }

  Future<void> _handleMutation({
    required Future<void> Function() action,
    void Function(List<AttendanceModel>)? onSuccess,
  }) async {
    try {
      await action();
      if (onSuccess != null && state.hasValue) {
        onSuccess(state.value!);
      }
      await refreshAttendance();
    } catch (e) {
      debugPrint('[AttendanceNotifier] Mutation error: $e');
      rethrow;
    }
  }

  Future<void> checkIn(String payload) async {
    await _handleMutation(
      action: () async {
        final repository = ref.read(attendanceRepositoryProvider);
        final result = await repository.checkIn(payload);
        result.fold((l) => throw l.message, (r) => null);
      },
    );
  }

  Future<void> checkOut(String payload) async {
    await _handleMutation(
      action: () async {
        final repository = ref.read(attendanceRepositoryProvider);
        final result = await repository.checkOut(payload);
        result.fold((l) => throw l.message, (r) => null);
      },
    );
  }
}
