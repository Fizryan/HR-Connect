import 'package:flutter/material.dart';
import 'package:hr_connect/features/attendance/data/models/attendance_model.dart';
import 'package:hr_connect/features/attendance/data/repositories/attendance_repository.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_state.dart';

class AttendanceProvider extends ValueNotifier<AttendanceState> {
  final AttendanceRepository repository;

  AttendanceProvider({required this.repository}) : super(const AttendanceState.initial());

  Future<void> fetchAllAttendances() async {
    value = const AttendanceState.loading();
    final result = await repository.getAllAttendances();
    result.fold(
      (failure) => value = AttendanceState.error(failure.message),
      (attendances) => value = AttendanceState.dataList(attendances),
    );
  }

  Future<void> getAttendanceByUid(String uid) async {
    value = const AttendanceState.loading();
    final result = await repository.getAttendanceByUid(uid);
    result.fold(
      (failure) => value = AttendanceState.error(failure.message),
      (attendance) => value = AttendanceState.data(attendance),
    );
  }

  Future<void> createAttendance(AttendanceModel attendanceData) async {
    value = const AttendanceState.loading();
    final result = await repository.createAttendance(attendanceData);
    result.fold(
      (failure) => value = AttendanceState.error(failure.message),
      (attendance) => value = const AttendanceState.success('Attendance created successfully'),
    );
  }

  Future<void> deleteAttendance(String uid) async {
    value = const AttendanceState.loading();
    final result = await repository.deleteAttendance(uid);
    result.fold(
      (failure) => value = AttendanceState.error(failure.message),
      (_) => value = const AttendanceState.success('Attendance deleted successfully'),
    );
  }
}