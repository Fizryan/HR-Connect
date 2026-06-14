import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

final leaveMeProvider = FutureProvider<List<LeaveModel>>((ref) async {
  final repository = ref.read(leaveRepositoryProvider);
  final result = await repository.getLeaveMe();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (leaves) => leaves,
  );
});

final pendingLeaveMeProvider = Provider<AsyncValue<List<LeaveModel>>>((ref) {
  final myLeaves = ref.watch(leaveMeProvider);

  return myLeaves.whenData((leaves) {
    return leaves
        .where((leave) => leave.status.name.toLowerCase() == 'pending')
        .toList();
  });
});

final leaveNotifierProvider =
    AsyncNotifierProvider<LeaveNotifier, List<LeaveModel>>(LeaveNotifier.new);

class LeaveNotifier extends BaseListNotifier<LeaveModel> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<LeaveModel>> build() async {
    final data = await _fetchLeaveLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<LeaveModel>> _fetchLeaveLogic() async {
    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.getAllLeaves();

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
    state = await AsyncValue.guard(_fetchLeaveLogic);

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
        ref.invalidate(leaveMeProvider);
      },
    );
  }

  Future<Either<Failure, void>> approveLeave(String id) async {
    final repository = ref.read(leaveRepositoryProvider);
    final currentUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.approveLeave(id),
      onSuccess: (_) {
        ref.invalidate(leaveMeProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((leave) {
          if (leave.id == id) {
            return leave.copyWith(
              status: RequestStatus.approved,
              approverId: currentUser?.id,
            );
          }
          return leave;
        }).toList();
      },
    );
  }

  Future<Either<Failure, void>> rejectLeave(String id) async {
    final repository = ref.read(leaveRepositoryProvider);
    final currentUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.rejectLeave(id),
      onSuccess: (_) {
        ref.invalidate(leaveMeProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((leave) {
          if (leave.id == id) {
            return leave.copyWith(
              status: RequestStatus.rejected,
              approverId: currentUser?.id,
            );
          }
          return leave;
        }).toList();
      },
    );
  }
}
