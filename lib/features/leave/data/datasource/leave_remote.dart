import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/error/core_exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

abstract class LeaveRemote {
  Future<List<LeaveModel>> getAllLeaves();
  Future<LeaveModel> getLeaveByUid(String uid);
  Future<LeaveModel> createLeave(Map<String, dynamic> leaveData);
  Future<LeaveModel> updateLeave(String uid, Map<String, dynamic> leaveData);
  Future<void> deleteLeave(String uid);
}

class LeaveRemoteImpl implements LeaveRemote {
  final ApiClient apiClient;

  LeaveRemoteImpl({required this.apiClient});

  @override
  Future<List<LeaveModel>> getAllLeaves() async {
    try {
      final response = await apiClient.dio.get('/leaves');
      final List leaveData = response.data['data'];
      return leaveData.map((json) => LeaveModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<LeaveModel> getLeaveByUid(String uid) async {
    try {
      final response = await apiClient.dio.get('/leaves/$uid');
      return LeaveModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<LeaveModel> createLeave(Map<String, dynamic> leaveData) async {
    try {
      final response = await apiClient.dio.post('/leaves', data: leaveData);
      return LeaveModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<LeaveModel> updateLeave(String uid, Map<String, dynamic> leaveData) async {
    try {
      final response = await apiClient.dio.put('/leaves/$uid', data: leaveData);
      return LeaveModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteLeave(String uid) async {
    try {
      await apiClient.dio.delete('/leaves/$uid');
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
