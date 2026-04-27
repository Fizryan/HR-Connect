// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OvertimeModel _$OvertimeModelFromJson(Map<String, dynamic> json) =>
    _OvertimeModel(
      uid: json['uid'] as String,
      requestedById: json['requestedById'] as String,
      approvedById: json['approvedById'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$OvertimeModelToJson(_OvertimeModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'requestedById': instance.requestedById,
      'approvedById': instance.approvedById,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
