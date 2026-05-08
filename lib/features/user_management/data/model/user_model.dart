import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromApi(Map<String, dynamic> json) {
    final userNode = json['user'] as Map<String, dynamic>? ?? json;
    final dataNode = userNode['data'] as Map<String, dynamic>? ?? {};

    final rawRole = dataNode['role'] as String? ?? '';
    String mappedRole = 'unknown';

    switch (rawRole) {
      case 'ROLE_ADMIN':
        mappedRole = 'admin';
        break;
      case 'ROLE_DIRECTOR':
        mappedRole = 'director';
        break;
      case 'ROLE_MANAGER':
        mappedRole = 'manager';
        break;
      case 'ROLE_SUPERVISOR':
        mappedRole = 'supervisor';
        break;
      case 'ROLE_STAFF':
        mappedRole = 'staff';
        break;
      default:
        mappedRole = 'unknown';
    }

    String? parseUnixToIso(dynamic timestamp) {
      if (timestamp == null) return null;
      final intSeconds = int.tryParse(timestamp.toString());
      if (intSeconds == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(intSeconds * 1000).toIso8601String();
    }

    return UserModel.fromJson({
      'id': userNode['id'],
      'email': dataNode['email'],
      'password': null, 
      'firstName': dataNode['firstName'],
      'lastName': dataNode['lastName'],
      'role': mappedRole,
      'avatarUrl': dataNode['avatarUrl'], 
      'isActive': userNode['isActive'] ?? true,
      'createdAt': parseUnixToIso(userNode['createdAt']),
      'updatedAt': parseUnixToIso(userNode['updatedAt']),
    });
  }
      
  String get fullName => '$firstName $lastName';
}