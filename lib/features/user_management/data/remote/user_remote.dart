import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRemote {
  Future<UserModel> getUserInfo();
  Future<List<UserModel>> getAllUsers({bool forceRefresh = false});
  Future<UserModel> getUserById(String id);
  Future<void> registerUser(UserData data, String password);
  Future<void> updateUser(String id, UserData data);
  Future<void> deleteUser(String id);
  Future<void> activateUser(String id);
  Future<void> deactivateUser(String id);
}

class UserRemoteImpl extends BaseRemote implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImpl({required this.apiClient});

  @override
  Future<UserModel> getUserInfo({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.profile, forceRefresh: true)
              as Map<String, dynamic>;
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    });
  }

  @override
  Future<List<UserModel>> getAllUsers({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.users, forceRefresh: true)
              as Map<String, dynamic>;
      return (response['user'] as List)
          .map((user) => UserModel.fromJson(user as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<UserModel> getUserById(String id) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.getUser(id)) as Map<String, dynamic>;
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    });
  }

  @override
  Future<void> registerUser(UserData data, String password) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {
        'data': data.toJson(),
        'password': password,
      };
      await apiClient.post(ApiEndpoints.usersRegister, data: payload);
    });
  }

  @override
  Future<void> updateUser(String id, UserData data) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {'data': data.toJson()};
      await apiClient.put(ApiEndpoints.putUser(id), data: payload);
    });
  }

  @override
  Future<void> deleteUser(String id) async {
    return apiCall(() async {
      await apiClient.delete(ApiEndpoints.deleteUser(id));
    });
  }

  @override
  Future<void> activateUser(String id) async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.activateUser(id));
    });
  }

  @override
  Future<void> deactivateUser(String id) async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.deactivateUser(id));
    });
  }
}
