// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserData _$UserDataFromJson(Map<String, dynamic> json) => _UserData(
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role'], unknownValue: Role.unknown),
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$UserDataToJson(_UserData instance) => <String, dynamic>{
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': _$RoleEnumMap[instance.role]!,
  'avatarUrl': instance.avatarUrl,
};

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.director: 'director',
  Role.manager: 'manager',
  Role.supervisor: 'supervisor',
  Role.staff: 'staff',
  Role.unknown: 'unknown',
};

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  data: UserData.fromJson(json['data'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool,
  createdAt: ApiDateUtils.parseToDateTime(json['createdAt']),
  updatedAt: ApiDateUtils.parseToDateTime(json['updatedAt']),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
