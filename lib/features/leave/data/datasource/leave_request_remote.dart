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
}

class LeaveRequestRemoteImp implements LeaveRequestRemote {
  final ApiClient apiClient;

  LeaveRequestRemoteImp({required this.apiClient});

  @override
  Future<List<LeaveRequestModel>> getLeaveRequests() async {
    try {
      final response = await apiClient.get(ApiEndpoints.leaveRequests);
      final List<dynamic> leaveRequestsList = response['request'] ?? [];
      return leaveRequestsList.map((leaveRequestJson) {
        return LeaveRequestModel.fromApi(
          leaveRequestJson as Map<String, dynamic>,
        );
      }).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LeaveRequestModel> getLeaveRequestsById(String id) async {
    try {
      final response = await apiClient.get(ApiEndpoints.leaveRequest(id));
      return LeaveRequestModel.fromApi(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LeaveRequestModel> updateLeaveRequest(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.putLeaveRequest(id),
        data: updateData,
      );
      return LeaveRequestModel.fromApi(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteLeaveRequest(String id) async {
    try {
      await apiClient.delete(ApiEndpoints.deleteLeaveRequest(id));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
