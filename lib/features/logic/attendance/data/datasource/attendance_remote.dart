import 'package:hr_connect/core/error/failures.dart';

import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/logic/attendance/data/models/attendance_model.dart';

abstract class AttendanceRemote {
  Future<List<AttendanceModel>> getAllAttendances();
  Future<AttendanceModel> getAttendanceByUid(String uid);
  Future<AttendanceModel> createAttendance(Map<String, dynamic> attendanceData);
  Future<void> deleteAttendance(String uid);
}

class AttendanceRemoteImpl implements AttendanceRemote {
  final ApiClient apiClient;

  AttendanceRemoteImpl({required this.apiClient});

  @override
  Future<List<AttendanceModel>> getAllAttendances() async {
    try {
      final response = await apiClient.get('/attendances');
      final List attendanceData = response['data'];
      return attendanceData
          .map((json) => AttendanceModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<AttendanceModel> getAttendanceByUid(String uid) async {
    try {
      final response = await apiClient.get('/attendances/$uid');
      return AttendanceModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<AttendanceModel> createAttendance(
    Map<String, dynamic> attendanceData,
  ) async {
    try {
      final response = await apiClient.post(
        '/attendances',
        data: attendanceData,
      );
      return AttendanceModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteAttendance(String uid) async {
    try {
      await apiClient.delete('/attendances/$uid');
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
