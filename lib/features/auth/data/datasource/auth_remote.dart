import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class AuthRemote {
  Future<AuthModel> login(String email, String password);
  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  );
  Future<void> logout(String refreshToken);
  Future<AuthModel> refreshToken(String token);
  Future<UserModel> getUserInfo();
}

class AuthRemoteImpl implements AuthRemote {
  final ApiClient apiClient;

  AuthRemoteImpl({required this.apiClient});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        '/v1/auth/login',
        data: {'email': email, 'password': password},
      );
      return AuthModel.success(
        accessToken: response.data['accessToken'],
        expTime: response.data['expTime'],
        refreshToken: response.data['refreshToken'],
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    try {
      await apiClient.post(
        '/v1/auth/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'role': role.name,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await apiClient.post(
        '/v1/auth/logout',
        data: {'refresh': refreshToken},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthModel> refreshToken(String token) async {
    try {
      final response = await apiClient.post(
        '/v1/auth/refresh',
        data: {'refresh': token},
      );
      return AuthModel.success(
        accessToken: response.data['accessToken'],
        expTime: response.data['expTime'],
        refreshToken: response.data['refreshToken'],
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final response = await apiClient.get('/v1/auth/me');
      return UserModel.fromJson(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
