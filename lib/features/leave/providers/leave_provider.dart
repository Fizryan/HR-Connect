import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';

final leaveNotifierProvider =
    AsyncNotifierProvider<LeaveNotifier, List<LeaveRequestModel>>(
      LeaveNotifier.new,
    );

class LeaveNotifier extends AsyncNotifier<List<LeaveRequestModel>> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<LeaveRequestModel>> build() async {
    final data = await _fetchLeaveRequestsLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<LeaveRequestModel>> _fetchLeaveRequestsLogic() async {
    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.getLeaveRequests();

    return result.fold(
      (failure) => throw failure.message,
      (leaveRequests) => leaveRequests,
    );
  }

  Future<void> fetchLeaveRequests() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 15;

    if (isCacheValid && state.hasValue && state.value!.isNotEmpty) {
      return;
    }

    await refreshLeaveRequests();
  }

  Future<void> refreshLeaveRequests() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchLeaveRequestsLogic);
    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<void> fetchLeaveRequestById(String id) async {
    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.getLeaveRequestById(id);

    result.fold(
      (failure) {
        debugPrint('Failed to fetch leave request: ${failure.message}');
      },
      (fetchedLeaveRequest) {
        if (state.hasValue) {
          final updatedList = state.value!.map((leaveRequest) {
            return leaveRequest.id == id ? fetchedLeaveRequest : leaveRequest;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> _handleMutation<T>({
    required Future<Either<Failure, T>> Function() action,
    List<LeaveRequestModel> Function(List<LeaveRequestModel> currentList)?
    optimisticUpdate,
    void Function(T successData)? onSuccess,
  }) async {
    final previousState = state;

    if (optimisticUpdate != null && previousState.hasValue) {
      state = AsyncValue.data(optimisticUpdate(previousState.value!));
    }

    final result = await action();

    result.fold(
      (failure) {
        state = AsyncValue<List<LeaveRequestModel>>.error(
          failure.message,
          StackTrace.current,
        // ignore: invalid_use_of_internal_member
        ).copyWithPrevious(previousState);
        Future.delayed(const Duration(seconds: 2), () {
          if (state.hasError && state.hasValue) {
            state = AsyncValue.data(state.value!);
          }
        });
      },
      (successData) {
        if (onSuccess != null) {
          onSuccess(successData);
        }
      },
    );
  }

  Future<void> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    await _handleMutation(
      action: () =>
          ref.read(leaveRepositoryProvider).updateLeaveRequest(id, updateData),
      onSuccess: (updatedLeaveRequest) {
        if (state.hasValue) {
          final updatedList = state.value!.map((leave) {
            return leave.id == id ? updatedLeaveRequest : leave;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> approveLeaveRequest(String id) async {
    await _handleMutation(
      action: () => ref.read(leaveRepositoryProvider).approveLeaveRequest(id),
      optimisticUpdate: (current) => current.map((leave) {
        return leave.id == id
            ? leave.copyWith(status: RequestStatus.approved)
            : leave;
      }).toList(),
    );
  }

  Future<void> rejectLeaveRequest(String id, String reason) async {
    await _handleMutation(
      action: () => ref.read(leaveRepositoryProvider).rejectLeaveRequest(id, reason),
      optimisticUpdate: (current) => current.map((leave) {
        return leave.id == id
            ? leave.copyWith(status: RequestStatus.rejected)
            : leave;
      }).toList(),
    );
  }

  Future<void> createLeaveRequest(Map<String, dynamic> request) async {
    await _handleMutation(
      action: () => ref.read(leaveRepositoryProvider).createLeaveRequest(request),
      onSuccess: (_) {
        fetchLeaveRequests();
      },
    );
  }
}
