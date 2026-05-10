import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final isCacheValid = lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 15;

    if (state.isLoading) return;

    if (isCacheValid && state.hasValue && state.value!.isNotEmpty) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      _fetchLeaveRequestsLogic,
    );
    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<void> refreshLeaveRequests() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      _fetchLeaveRequestsLogic,
    );
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

  Future<void> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    final previousState = state;

    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.updateLeaveRequest(id, updateData);

    result.fold(
      (failure) {
        state = AsyncValue<List<LeaveRequestModel>>.error(
          failure.message,
          StackTrace.current,
        );
        Future.delayed(const Duration(seconds: 2), () {
          state = previousState;
        });
      },
      (updatedLeaveRequest) {
        if (previousState.hasValue) {
          final updatedList = previousState.value!.map((leaveRequest) {
            return leaveRequest.id == id ? updatedLeaveRequest : leaveRequest;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> deleteLeaveRequest(String id) async {
    final previousState = state;

    if (previousState.hasValue) {
      final optimisticList = previousState.value!
          .where((leaveRequest) => leaveRequest.id != id)
          .toList();
      state = AsyncValue.data(optimisticList);
    }

    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.deleteLeaveRequest(id);

    result.fold((failure) {
      state = AsyncValue<List<LeaveRequestModel>>.error(
        failure.message,
        StackTrace.current,
      );
      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }
}
