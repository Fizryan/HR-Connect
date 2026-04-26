import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/core_exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/overtime/data/models/overtime_model.dart';

abstract class OvertimeRemote {
  Future<List<OvertimeModel>> getAllOvertimesRequests();
  Future<OvertimeModel> getOvertimeByUid(String uid);
  Future<OvertimeModel> createOvertimeRequest(Map<String, dynamic> overtimeData);
  Future<OvertimeModel> updateOvertimeStatus(
    String uid,
    Map<String, dynamic> overtimeData,
  );
  Future<void> deleteOvertimeRequest(String uid);
}

class OvertimeRemoteImpl implements OvertimeRemote {
  final ApiClient apiClient;

  OvertimeRemoteImpl({required this.apiClient});

  @override
  Future<List<OvertimeModel>> getAllOvertimesRequests() async {
    try {
      final response = await apiClient.dio.get('/overtimes');
      final List overtimeData = response.data['data'];
      return overtimeData.map((json) => OvertimeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<OvertimeModel> getOvertimeByUid(String uid) async {
    try {
      final response = await apiClient.dio.get('/overtimes/$uid');
      return OvertimeModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<OvertimeModel> createOvertimeRequest(
    Map<String, dynamic> overtimeData,
  ) async {
    try {
      final response = await apiClient.dio.post(
        '/overtimes',
        data: overtimeData,
      );
      return OvertimeModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<OvertimeModel> updateOvertimeStatus(
    String uid,
    Map<String, dynamic> overtimeData,
  ) async {
    try {
      final response = await apiClient.dio.put(
        '/overtimes/$uid',
        data: overtimeData,
      );
      return OvertimeModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteOvertimeRequest(String uid) async {
    try {
      await apiClient.dio.delete('/overtimes/$uid');
    } on DioException catch (e) {
      throw CoreException.serverFailure(e);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
