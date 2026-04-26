// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      uid: json['uid'] as String,
      requestedById: json['requestedById'] as String,
      loginTme: json['login_time'] == null
          ? null
          : DateTime.parse(json['login_time'] as String),
      logoutTime: json['logout_time'] == null
          ? null
          : DateTime.parse(json['logout_time'] as String),
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'requestedById': instance.requestedById,
      'login_time': instance.loginTme?.toIso8601String(),
      'logout_time': instance.logoutTime?.toIso8601String(),
    };
