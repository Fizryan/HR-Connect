import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';

abstract class AuthRemote {
  Future<AuthModel> login(String email, String password);
  Future<void> logout();
  Future<AuthModel> refreshToken(String token);
  Future<void> updateToken(String token);
  Future<void> clearToken();
  Future<void> changePassword(String newPassword, String oldPassword);
  Future<void> resetPassword(String id, String newPassword);
}

class AuthRemoteImpl extends BaseRemote implements AuthRemote {
  final ApiClient apiClient;

  AuthRemoteImpl({required this.apiClient});

  @override
  Future<AuthModel> login(String email, String password) async {
    return apiCall(() async {
      final response =
          await apiClient.post(
                ApiEndpoints.authLogin,
                data: {'email': email, 'password': password},
              )
              as Map<String, dynamic>;

      response['runtimeType'] = 'success';

      return AuthModel.fromJson(response);
    });
  }

  @override
  Future<void> logout() async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.authLogout);
    });
  }

  @override
  Future<AuthModel> refreshToken(String token) async {
    return apiCall(() async {
      final response =
          await apiClient.post(
                ApiEndpoints.authRefresh,
                data: {'refreshToken': token},
              )
              as Map<String, dynamic>;

      response['runtimeType'] = 'success';
      return AuthModel.fromJson(response);
    });
  }

  @override
  Future<void> updateToken(String token) async {
    apiClient.updateToken(token);
  }

  @override
  Future<void> clearToken() async {
    apiClient.clearToken();
  }

  @override
  Future<void> changePassword(String newPassword, String oldPassword) async {
    return apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authChange,
        data: {'newPassword': newPassword, 'oldPassword': oldPassword},
      );
    });
  }

  @override
  Future<void> resetPassword(String id, String newPassword) async {
    return apiCall(() async {
      await apiClient.post(
        ApiEndpoints.authReset,
        data: {'id': id, 'newPassword': newPassword},
      );
    });
  }
}
