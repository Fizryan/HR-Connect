import 'package:flutter/material.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/data/repositories/leave_repository.dart';
import 'package:hr_connect/features/leave/presentation/providers/leave_state.dart';

class LeaveProvider extends ValueNotifier<LeaveState> {
  final LeaveRepository repository;

  LeaveProvider({required this.repository}) : super(const LeaveState.initial());
  
  Future<void> fetchAllLeaves() async {
    value = const LeaveState.loading();
    final result = await repository.getAllLeaves();
    result.fold(
      (failure) => value = LeaveState.error(failure.message),
      (leaves) => value = LeaveState.dataList(leaves),
    );
  }

  Future<void> getLeaveByUid(String uid) async {
    value = const LeaveState.loading();
    final result = await repository.getLeaveByUid(uid);
    result.fold(
      (failure) => value = LeaveState.error(failure.message),
      (leaves) => value = LeaveState.data(leaves),
    );
  }

  Future<void> createLeave(LeaveModel leaveData) async {
    value = const LeaveState.loading();
    final result = await repository.createLeave(leaveData);
    result.fold(
      (failure) => value = LeaveState.error(failure.message),
      (leave) => value = const LeaveState.success('Leave created successfully'),
    );
  }

  Future<void> updateLeave(LeaveModel leaveData) async {
    value = const LeaveState.loading();
    final result = await repository.updateLeave(leaveData);
    result.fold(
      (failure) => value = LeaveState.error(failure.message),
      (leave) => value = const LeaveState.success('Leave updated successfully'),
    );
  }

  Future<void> deleteLeave(String uid) async {
    value = const LeaveState.loading();
    final result = await repository.deleteLeave(uid);
    result.fold(
      (failure) => value = LeaveState.error(failure.message),
      (_) => value = const LeaveState.success('Leave deleted successfully'),
    );
  }
}