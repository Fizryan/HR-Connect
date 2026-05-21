import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/const/role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    String? password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? avatarUrl,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromApi(Map<String, dynamic> json) {
    final userNode = json['user'] as Map<String, dynamic>? ?? json;
    final dataNode = userNode['data'] as Map<String, dynamic>? ?? {};
    final rawRole = dataNode['role'] as String? ?? '';
    final String mappedRole = Role.rawToRole(rawRole).name;

    return UserModel.fromJson({
      'id': userNode['id'],
      'email': dataNode['email'],
      'password': null,
      'firstName': dataNode['firstName'],
      'lastName': dataNode['lastName'],
      'role': mappedRole,
      'avatarUrl': dataNode['avatarUrl'],
      'isActive': userNode['isActive'] ?? true,
      'createdAt': userNode['createdAt'],
      'updatedAt': userNode['updatedAt'],
    });
  }

  String get fullName => '$firstName $lastName';
}
