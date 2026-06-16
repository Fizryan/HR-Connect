import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';

abstract class BaseSharedLeaveNotifier extends BaseListNotifier<LeaveModel> {
  DateTime? lastFetchTime;

  Future<Either<Failure, List<LeaveModel>>> fetchFromRepository();

  @override
  FutureOr<List<LeaveModel>> build() async {
    final data = await _fetchLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<LeaveModel>> _fetchLogic() async {
    final result = await fetchFromRepository();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (leaves) => leaves,
    );
  }

  Future<void> fetchLeaves() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 10;

    if (isCacheValid && state.hasValue) return;

    await refreshLeaves();
  }

  Future<void> refreshLeaves() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchLogic);

    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<Either<Failure, void>> createLeave(LeaveData data) async {
    final repository = ref.read(leaveRepositoryProvider);
    return handleMutation(
      action: () => repository.createLeave(data),
      onSuccess: (_) {
        refreshLeaves();
        if (this is LeaveMeNotifier) {
          ref.invalidate(leaveNotifierProvider);
        } else if (this is LeaveNotifier) {
          ref.invalidate(leaveMeNotifierProvider);
        }
      },
    );
  }
}
