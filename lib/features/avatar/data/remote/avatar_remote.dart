import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';

abstract class AvatarRemote {
  Future<String> uploadAvatar(File file);
  Future<String> getAvatarUrl(String filename);
}

class AvatarRemoteImpl extends BaseRemote implements AvatarRemote {
  final ApiClient apiClient;

  AvatarRemoteImpl({required this.apiClient});

  @override
  Future<String> uploadAvatar(File file) async {
    return apiCall(() async {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response =
          await apiClient.post(ApiEndpoints.avatarUpload(), data: formData)
              as Map<String, dynamic>;

      return response['url'] as String;
    });
  }

  @override
  Future<String> getAvatarUrl(String filename) async {
    return apiCall(() async {
      return await apiClient.get(ApiEndpoints.getAvatarUrl(filename));
    });
  }
}
