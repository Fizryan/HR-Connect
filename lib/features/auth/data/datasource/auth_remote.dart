import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

abstract class AuthRemote {
  Future<AuthModel> login(String email, String password);
  Future<UserModel> getUserProfile();
}

class AuthRemoteImpl implements AuthRemote {
  final ApiClient apiClient;

  AuthRemoteImpl({required this.apiClient});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure(
          'Connection timeout. Please try again later',
        );
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await apiClient.dio.get('/profile');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure(
          'Connection timeout. Please try again later',
        );
      }
      final errorMessage = e.response?.data['message'] ?? 'An error occurred';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
