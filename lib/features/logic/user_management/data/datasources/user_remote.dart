import 'package:hr_connect/core/error/failures.dart';

import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';
import 'package:hr_connect/core/network/api_client.dart';

abstract class UserRemote {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> getUserByUid(String uid);
  Future<UserModel> createUser(Map<String, dynamic> userData);
  Future<UserModel> updateUser(String uid, Map<String, dynamic> userData);
  Future<void> deleteUser(String uid);
}

class UserRemoteImpl implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImpl({required this.apiClient});

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await apiClient.get('/users');
      final List userData = response['data'];
      return userData.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> getUserByUid(String uid) async {
    try {
      final response = await apiClient.get('/users/$uid');
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('/users', data: userData);
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> updateUser(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await apiClient.put('/users/$uid', data: userData);
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      await apiClient.delete('/users/$uid');
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
