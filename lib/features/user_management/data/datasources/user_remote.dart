import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/core/network/api_client.dart';

abstract class UserRemote {
  Future<UserModel> getUsers();
}

class UserRemoteImpl implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImpl({required this.apiClient});

  @override
  Future<UserModel> getUsers() async {
    try {
      final response = await apiClient.dio.get('/users');
      final userData = response.data['data'];
      return UserModel.fromJson(userData);
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
