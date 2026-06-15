import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';

abstract class AttendanceRemote {
  Future<List<AttendanceData>> getAttendanceMe({bool forceRefresh = false});
  Future<List<AttendanceModel>> getAllAttendance({bool forceRefresh = false});
  Future<List<AttendanceData>> getAttendanceById(
    String id, {
    bool forceRefresh = false,
  });
  Future<String> generateAttendance();
  Future<void> checkInAt(String data);
  Future<void> checkOutAt(String data);
}

class AttendanceRemoteImpl extends BaseRemote implements AttendanceRemote {
  final ApiClient apiClient;

  AttendanceRemoteImpl({required this.apiClient});

  @override
  Future<List<AttendanceData>> getAttendanceMe({
    bool forceRefresh = false,
  }) async {
    return apiCall(() async {
      final response =
          await apiClient.get(
                ApiEndpoints.attendanceMe,
                forceRefresh: forceRefresh,
              )
              as Map<String, dynamic>;
      return (response['attendance'] as List)
          .map(
            (attendance) =>
                AttendanceData.fromJson(attendance as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<List<AttendanceModel>> getAllAttendance({
    bool forceRefresh = false,
  }) async {
    return apiCall(() async {
      final response =
          await apiClient.get(
                ApiEndpoints.attendance,
                forceRefresh: forceRefresh,
              )
              as Map<String, dynamic>;
      return (response['userAttendance'] as List)
          .map(
            (attendance) =>
                AttendanceModel.fromJson(attendance as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<List<AttendanceData>> getAttendanceById(
    String id, {
    bool forceRefresh = false,
  }) async {
    return apiCall(() async {
      final response =
          await apiClient.get(
                ApiEndpoints.attendanceById(id),
                forceRefresh: forceRefresh,
              )
              as Map<String, dynamic>;
      return (response['attendance'] as List)
          .map(
            (attendance) =>
                AttendanceData.fromJson(attendance as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<String> generateAttendance() async {
    return apiCall(() async {
      final response =
          await apiClient.post(ApiEndpoints.attendanceGenerate)
              as Map<String, dynamic>;
      return (response['url'] as String);
    });
  }

  @override
  Future<void> checkInAt(String data) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {'payload': data};
      await apiClient.post(ApiEndpoints.attendanceCheckIn, data: payload);
    });
  }

  @override
  Future<void> checkOutAt(String data) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {'payload': data};
      await apiClient.post(ApiEndpoints.attendanceCheckOut, data: payload);
    });
  }
}
