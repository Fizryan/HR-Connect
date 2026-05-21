// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(scannedAt: json['scannedAt'] as String);

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{'scannedAt': instance.scannedAt};

_UserAttendanceModel _$UserAttendanceModelFromJson(Map<String, dynamic> json) =>
    _UserAttendanceModel(
      userId: json['userId'] as String,
      attendance:
          (json['attendance'] as List<dynamic>?)
              ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserAttendanceModelToJson(
  _UserAttendanceModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'attendance': instance.attendance,
};

_AttendanceGenerateModel _$AttendanceGenerateModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceGenerateModel(
  png: json['png'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$AttendanceGenerateModelToJson(
  _AttendanceGenerateModel instance,
) => <String, dynamic>{'png': instance.png, 'url': instance.url};
