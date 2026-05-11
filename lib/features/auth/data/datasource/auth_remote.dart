import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/const/role.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class AuthRemote {
  Future<AuthModel> login(String email, String password);
  Future<void> register(
    String? avatarUrl,
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

  Future<T> _apiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthModel> login(String email, String password) async {
    return _apiCall(() async {
      final response = await apiClient.post(
        ApiEndpoints.authLogin,
        data: {'email': email, 'password': password},
      );
      return AuthModel.success(
        accessToken: response['accessToken'],
        expTime: response['expTime'],
        refreshToken: response['refreshToken'],
      );
    });
  }

  @override
  Future<void> register(
    String? avatarUrl,
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.usersRegister,
        data: {
          'data': {
            'avatarUrl': avatarUrl,
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'role': Role.roleToRaw(role),
          },
          'password': password,
        },
      );
    });
  }

  @override
  Future<void> logout(String refreshToken) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authLogout,
        data: {'refresh': refreshToken},
      );
    });
  }

  @override
  Future<AuthModel> refreshToken(String token) async {
    return _apiCall(() async {
      final response = await apiClient.post(
        ApiEndpoints.authRefresh,
        data: {'refresh': token},
      );
      return AuthModel.success(
        accessToken: response['accessToken'],
        expTime: response['expTime'],
        refreshToken: response['refreshToken'],
      );
    });
  }

  @override
  Future<UserModel> getUserInfo() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.profile);
      return UserModel.fromApi(response as Map<String, dynamic>);
    });
  }
}
