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
  Future<void> deleteLeaveRequest(String id);
  Future<void> approveLeaveRequest(String id);
  Future<void> rejectLeaveRequest(String id);
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
      final response = await apiClient.get(ApiEndpoints.leaveRequests);
      final List<dynamic> leaveRequestsList = response['request'] ?? [];
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
      final response = await apiClient.get(ApiEndpoints.leaveRequest(id));
      return LeaveRequestModel.fromApi(response.data);
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
      );
      return LeaveRequestModel.fromApi(response.data);
    });
  }

  @override
  Future<void> deleteLeaveRequest(String id) async {
    return _apiCall(() async {
      await apiClient.delete(ApiEndpoints.deleteLeaveRequest(id));
    });
  }

  @override
  Future<void> approveLeaveRequest(String id) async {
    return _apiCall(() async {
      await apiClient.post(ApiEndpoints.approveLeaveRequest(id));
    });
  }

  @override
  Future<void> rejectLeaveRequest(String id) async {
    return _apiCall(() async {
      await apiClient.post(ApiEndpoints.rejectLeaveRequest(id));
    });
  }
}
