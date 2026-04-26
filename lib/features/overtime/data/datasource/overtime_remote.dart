import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/overtime/data/models/overtime_model.dart';

abstract class OvertimeRemote {
  Future<List<OvertimeModel>> getAllOvertimesRequests();
  Future<OvertimeModel> getOvertimeByUid(String uid);
  Future<OvertimeModel> createOvertimeRequest(
    Map<String, dynamic> overtimeData,
  );
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
      final response = await apiClient.get('/overtimes');
      final List overtimeData = response['data'];
      return overtimeData.map((json) => OvertimeModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<OvertimeModel> getOvertimeByUid(String uid) async {
    try {
      final response = await apiClient.get('/overtimes/$uid');
      return OvertimeModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<OvertimeModel> createOvertimeRequest(
    Map<String, dynamic> overtimeData,
  ) async {
    try {
      final response = await apiClient.post('/overtimes', data: overtimeData);
      return OvertimeModel.fromJson(response['data']);
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
      final response = await apiClient.put(
        '/overtimes/$uid',
        data: overtimeData,
      );
      return OvertimeModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteOvertimeRequest(String uid) async {
    try {
      await apiClient.delete('/overtimes/$uid');
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
