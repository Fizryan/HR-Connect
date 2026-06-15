import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/core/config/date_utils.dart';
import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

abstract class LeaveRemote {
  Future<List<LeaveModel>> getLeaveMe();
  Future<List<LeaveModel>> getAllLeaves();
  Future<List<LeaveModel>> getPendingLeaves();
  Future<LeaveModel> getLeaveById(String id);
  Future<void> createLeave(LeaveData data);
  Future<void> approveLeave(String id);
  Future<void> rejectLeave(String id);
}

class LeaveRemoteImpl extends BaseRemote implements LeaveRemote {
  final ApiClient apiClient;

  LeaveRemoteImpl({required this.apiClient});

  @override
  Future<List<LeaveModel>> getLeaveMe({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.leaveMe, forceRefresh: true)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((leave) => LeaveModel.fromJson(leave as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<LeaveModel>> getAllLeaves({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.leaveRequests, forceRefresh: true)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((leave) => LeaveModel.fromJson(leave as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<LeaveModel>> getPendingLeaves() async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.leavePendingMe)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((leave) => LeaveModel.fromJson(leave as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<LeaveModel> getLeaveById(String id) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.leaveRequest(id))
              as Map<String, dynamic>;
      return LeaveModel.fromJson(response['request'] as Map<String, dynamic>);
    });
  }

  @override
  Future<void> createLeave(LeaveData data) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {
        'request': {
          'type': data.type,
          'description': data.description,
          'startDate': ApiDateUtils.dateToApiString(data.startDate),
          'endDate': ApiDateUtils.dateToApiString(data.endDate),
        },
      };
      await apiClient.post(ApiEndpoints.createLeaveRequest, data: payload);
    });
  }

  @override
  Future<void> approveLeave(String id) async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.approveLeaveRequest(id));
    });
  }

  @override
  Future<void> rejectLeave(String id) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {'reason': 'rejected'};
      await apiClient.post(ApiEndpoints.rejectLeaveRequest(id), data: payload);
    });
  }
}
