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
      final response = await apiClient.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return AuthModel.fromJson(response);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await apiClient.get('/profile');
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw ServerFailure('Failed to process data: $e');
    }
  }
}
