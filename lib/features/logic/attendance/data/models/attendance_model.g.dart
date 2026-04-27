// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      uid: json['uid'] as String,
      requestedById: json['requestedById'] as String,
      loginTme: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      logoutTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      dateCreated: json['date_created'] == null
          ? null
          : DateTime.parse(json['date_created'] as String),
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'requestedById': instance.requestedById,
      'start_time': instance.loginTme?.toIso8601String(),
      'end_time': instance.logoutTime?.toIso8601String(),
      'date_created': instance.dateCreated?.toIso8601String(),
    };
