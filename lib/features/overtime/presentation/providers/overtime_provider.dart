import 'package:flutter/material.dart';
import 'package:hr_connect/features/overtime/data/models/overtime_model.dart';
import 'package:hr_connect/features/overtime/data/repositories/overtime_repository.dart';
import 'package:hr_connect/features/overtime/presentation/providers/overtime_state.dart';

class OvertimeProvider extends ValueNotifier<OvertimeState> {
  final OvertimeRepository repository;

  OvertimeProvider({required this.repository})
    : super(const OvertimeState.initial());

  Future<void> fetchAllOvertimes() async {
    value = const OvertimeState.loading();
    final result = await repository.getAllOvertimeRequests();
    result.fold(
      (failure) => value = OvertimeState.error(failure.message),
      (overtimes) => value = OvertimeState.dataList(overtimes),
    );
  }

  Future<void> getOvertimeByUid(String uid) async {
    value = const OvertimeState.loading();
    final result = await repository.getOvertimeById(uid);
    result.fold(
      (failure) => value = OvertimeState.error(failure.message),
      (overtime) => value = OvertimeState.data(overtime),
    );
  }

  Future<void> createOvertime(OvertimeModel overtime) async {
    value = const OvertimeState.loading();
    final result = await repository.createOvertimeRequest(overtime);
    result.fold(
      (failure) => value = OvertimeState.error(failure.message),
      (overtime) =>
          value = const OvertimeState.success('Overtime created successfully'),
    );
  }

  Future<void> updateOvertime(OvertimeModel overtime) async {
    value = const OvertimeState.loading();
    final result = await repository.updateOvertimeStatus(overtime);
    result.fold(
      (failure) => value = OvertimeState.error(failure.message),
      (overtime) =>
          value = const OvertimeState.success('Overtime updated successfully'),
    );
  }

  Future<void> deleteOvertime(String uid) async {
    value = const OvertimeState.loading();
    final result = await repository.deleteOvertimeRequest(uid);
    result.fold(
      (failure) => value = OvertimeState.error(failure.message),
      (_) =>
          value = const OvertimeState.success('Overtime deleted successfully'),
    );
  }
}
