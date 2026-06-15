// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceData _$AttendanceDataFromJson(Map<String, dynamic> json) =>
    _AttendanceData(
      checkInAt: json['checkInAt'] as String,
      checkOutAt: json['checkOutAt'] as String,
      workday: json['workday'] as String,
    );

Map<String, dynamic> _$AttendanceDataToJson(_AttendanceData instance) =>
    <String, dynamic>{
      'checkInAt': instance.checkInAt,
      'checkOutAt': instance.checkOutAt,
      'workday': instance.workday,
    };

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      userId: json['userId'] as String,
      attendance: (json['attendance'] as List<dynamic>)
          .map((e) => AttendanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'attendance': instance.attendance,
    };
