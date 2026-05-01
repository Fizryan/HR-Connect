import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRemote {
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20});
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(String id, Map<String, dynamic> updateData);
  Future<void> deactivateUser(String id);
}

class UserRemoteImp implements UserRemote {
  final ApiClient apiClient;

  UserRemoteImp({required this.apiClient});

  @override
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.get(
        '/v1/users',
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> rawList = response['data'] ?? [];
      return rawList.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await apiClient.get('v1/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(String id, Map<String, dynamic> updateData) async {
    try {
      final response = await apiClient.put(
        '/v1/users/$id',
        data: updateData,
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deactivateUser(String id) async {
    try {
      await apiClient.delete('/v1/users/$id');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}