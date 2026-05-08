// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSuccess _$AuthSuccessFromJson(Map<String, dynamic> json) => _AuthSuccess(
  accessToken: json['accessToken'] as String,
  expTime: json['expTime'] as String,
  refreshToken: json['refreshToken'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AuthSuccessToJson(_AuthSuccess instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expTime': instance.expTime,
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };

_AuthError _$AuthErrorFromJson(Map<String, dynamic> json) => _AuthError(
  message: json['message'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$AuthErrorToJson(_AuthError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };
