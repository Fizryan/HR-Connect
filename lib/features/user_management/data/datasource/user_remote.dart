import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRemote {
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20});
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(String id, Map<String, dynamic> updateData);
  Future<void> activateUser(String id);
  Future<void> deactivateUser(String id);
  Future<void> deleteUser(String id);
}

class UserRemoteImp implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImp({required this.apiClient});

  Future<T>_apiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    return _apiCall(() async {
      final response = await apiClient.get(
        ApiEndpoints.users,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> usersList = response['user'] ?? [];
      return usersList.map((userJson) {
        return UserModel.fromApi(userJson as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<UserModel> getUserById(String id) async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.getUser(id));
      return UserModel.fromApi(response as Map<String, dynamic>);
    });
  }

  @override
  Future<UserModel> updateUser(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _apiCall(() async {
      await apiClient.put(
        ApiEndpoints.putUser(id),
        data: {'data': updateData},
      );
      return await getUserById(id);
    });
  }

  @override
  Future<void> activateUser(
    String id,
  ) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.activateUser(id),
      );
    });
  }

  @override
  Future<void> deactivateUser(
    String id,
  ) async {
    return _apiCall(() async {
      await apiClient.post(
        ApiEndpoints.deactivateUser(id),
      );
    });
  }

  @override
  Future<void> deleteUser(String id) async {
    return _apiCall(() async {
      await apiClient.delete(ApiEndpoints.deleteUser(id));
    });
  }
}
