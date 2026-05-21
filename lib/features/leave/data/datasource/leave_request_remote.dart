import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';

abstract class LeaveRequestRemote {
  Future<List<LeaveRequestModel>> getLeaveRequests();
  Future<LeaveRequestModel> getLeaveRequestsById(String id);
  Future<LeaveRequestModel> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  );
  Future<List<LeaveRequestModel>> getLeaveRequestsMe();
  Future<List<LeaveRequestModel>> getLeaveRequestsPendingMe();
  Future<void> createLeaveRequest(Map<String, dynamic> request);
  Future<void> approveLeaveRequest(String id);
  Future<void> rejectLeaveRequest(String id, String reason);
}

class LeaveRequestRemoteImp implements LeaveRequestRemote {
  final ApiClient apiClient;

  LeaveRequestRemoteImp({required this.apiClient});

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
  Future<List<LeaveRequestModel>> getLeaveRequests() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.leaveRequests) as Map<String, dynamic>;
      final List<dynamic> leaveRequestsList = response['requests'] as List<dynamic>? ?? [];
      return leaveRequestsList.map((leaveRequestJson) {
        return LeaveRequestModel.fromApi(
          leaveRequestJson as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  @override
  Future<LeaveRequestModel> getLeaveRequestsById(String id) async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.leaveRequest(id)) as Map<String, dynamic>;
      return LeaveRequestModel.fromApi(response);
    });
  }

  @override
  Future<LeaveRequestModel> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _apiCall(() async {
      final response = await apiClient.put(
        ApiEndpoints.putLeaveRequest(id),
        data: updateData,
      ) as Map<String, dynamic>;
      return LeaveRequestModel.fromApi(response);
    });
  }

  @override
  Future<List<LeaveRequestModel>> getLeaveRequestsMe() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.leaveMe) as Map<String, dynamic>;
      final List<dynamic> leaveRequestsList = response['requests'] as List<dynamic>? ?? [];
      return leaveRequestsList.map((leaveRequestJson) {
        return LeaveRequestModel.fromApi(
          leaveRequestJson as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  @override
  Future<List<LeaveRequestModel>> getLeaveRequestsPendingMe() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.leavePendingMe) as Map<String, dynamic>;
      final List<dynamic> leaveRequestsList = response['requests'] as List<dynamic>? ?? [];
      return leaveRequestsList.map((leaveRequestJson) {
        return LeaveRequestModel.fromApi(
          leaveRequestJson as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  @override
  Future<void> createLeaveRequest(Map<String, dynamic> request) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.createLeaveRequest,
        data: request,
      );
    });
  }

  @override
  Future<void> approveLeaveRequest(String id) async {
    return _apiCall(() async {
      await apiClient.post(ApiEndpoints.approveLeaveRequest(id));
    });
  }

  @override
  Future<void> rejectLeaveRequest(String id, String reason) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.rejectLeaveRequest(id),
        data: {'reason': reason},
      );
    });
  }
}
