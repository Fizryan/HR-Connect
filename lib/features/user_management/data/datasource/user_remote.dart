import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRemote {
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20});
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(String id, Map<String, dynamic> updateData);
  Future<UserModel> deactivateUser(String id, Map<String, dynamic> updateData);
  Future<void> deleteUser(String id);
}

class UserRemoteImp implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImp({required this.apiClient});

  @override
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.users,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> usersList = response['user'] ?? [];
      return usersList.map((userJson) {
        return UserModel.fromApi(userJson as Map<String, dynamic>);
      }).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await apiClient.get(ApiEndpoints.getUser(id));
      return UserModel.fromApi(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.putUser(id),
        data: updateData,
      );
      return UserModel.fromApi(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> deactivateUser(String id, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.putUser(id),
        data: updateData,
      );
      return UserModel.fromApi(response.data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await apiClient.delete(ApiEndpoints.deleteUser(id));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
