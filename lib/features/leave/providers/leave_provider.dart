import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';

final leaveNotifierProvider =
    AsyncNotifierProvider<LeaveNotifier, List<LeaveRequestModel>>(
      LeaveNotifier.new,
    );

class LeaveNotifier extends AsyncNotifier<List<LeaveRequestModel>> {
  @override
  FutureOr<List<LeaveRequestModel>> build() async {
    return _fetchLeaveRequestsLogic();
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchLeaveRequestsLogic);
  }

  Future<void> fetchLeaveRequestById(String id) async {
    state = const AsyncValue.loading();

    final repository = ref.read(leaveRepositoryProvider);
    final result = await repository.getLeaveRequestById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (leaveRequest) => AsyncValue.data([leaveRequest]),
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
