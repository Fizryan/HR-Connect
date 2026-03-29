import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
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
      final response = await apiClient.dio.get('/users');
      final List userData = response.data['data'];
      return userData.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout. Please try again later');
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> getUserByUid(String uid) async {
    try {
      final response = await apiClient.dio.get('/users/$uid');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout. Please try again later');
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.dio.post('/users', data: userData);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout. Please try again later');
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> updateUser(String uid, Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.dio.put('/users/$uid', data: userData);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout. Please try again later');
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      await apiClient.dio.delete('/users/$uid');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout. Please try again later');
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
