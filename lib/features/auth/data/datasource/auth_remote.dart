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
  Future<void> logout();
  Future<AuthModel> refreshToken(String token);
  Future<UserModel> getUserInfo();
  Future<void> changePassword(String newPassword, String oldPassword);
  Future<void> resetPassword(String id, String newPassword);
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
      ) as Map<String, dynamic>;
      return AuthModel.success(
        accessToken: response['accessToken'] as String,
        expTime: response['expTime'].toString(),
        refreshToken: response['refreshToken'] as String,
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
  Future<void> logout() async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authLogout,
      );
    });
  }

  @override
  Future<AuthModel> refreshToken(String token) async {
    return _apiCall(() async {
      final response = await apiClient.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': token},
      ) as Map<String, dynamic>;
      return AuthModel.success(
        accessToken: response['accessToken'] as String,
        expTime: response['expTime'].toString(),
        refreshToken: response['refreshToken'] as String,
      );
    });
  }

  @override
  Future<void> changePassword(String newPassword, String oldPassword) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authChange,
        data: {'newPassword': newPassword, 'oldPassword': oldPassword},
      );
    });
  }

  @override
  Future<void> resetPassword(String id, String newPassword) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authReset,
        data: {'id': id, 'newPassword': newPassword},
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
