import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/attendance/data/model/attendance_model.dart';

abstract class AttendanceRemote {
  Future<List<UserAttendanceModel>> getAttendance();
  Future<List<AttendanceModel>> getAttendanceMe();
  Future<List<AttendanceModel>> getAttendanceById(String id);
  Future<void> checkIn(String payload);
  Future<void> checkOut(String payload);
  Future<AttendanceGenerateModel> generateAttendance();
  Future<AttendanceGenerateModel> todayAttendance();
}

class AttendanceRemoteImp implements AttendanceRemote {
  final ApiClient apiClient;

  AttendanceRemoteImp({required this.apiClient});

  Future<T> _apiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Something went wrong');
    }
  }

  @override
  Future<List<UserAttendanceModel>> getAttendance() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.attendance) as Map<String, dynamic>;
      final List<dynamic> userAttendance = response['userAttendance'] as List<dynamic>? ?? [];
      return userAttendance
          .map((json) => UserAttendanceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<AttendanceModel>> getAttendanceMe() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.attendanceMe) as Map<String, dynamic>;
      final List<dynamic> attendance = response['attendance'] as List<dynamic>? ?? [];
      return attendance
          .map((json) => AttendanceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<AttendanceModel>> getAttendanceById(String id) async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.attendanceById(id)) as Map<String, dynamic>;
      final List<dynamic> attendance = response['attendance'] as List<dynamic>? ?? [];
      return attendance
          .map((json) => AttendanceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> checkIn(String payload) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.attendanceCheckIn,
        data: {'payload': payload},
      );
    });
  }

  @override
  Future<void> checkOut(String payload) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.attendanceCheckOut,
        data: {'payload': payload},
      );
    });
  }

  @override
  Future<AttendanceGenerateModel> generateAttendance() async {
    return _apiCall(() async {
      final response = await apiClient.post(ApiEndpoints.attendanceGenerate) as Map<String, dynamic>;
      return AttendanceGenerateModel.fromJson(response);
    });
  }

  @override
  Future<AttendanceGenerateModel> todayAttendance() async {
    return _apiCall(() async {
      final response = await apiClient.post(ApiEndpoints.attendanceToday) as Map<String, dynamic>;
      return AttendanceGenerateModel.fromJson(response);
    });
  }
}
