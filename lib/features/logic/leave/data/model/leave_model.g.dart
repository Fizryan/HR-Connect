// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => _LeaveModel(
  uid: json['uid'] as String,
  requestedById: json['requestedById'] as String,
  approvedById: json['approvedById'] as String?,
  type: $enumDecode(_$LeaveTypeEnumMap, json['type']),
  reason: json['reason'] as String,
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

Map<String, dynamic> _$LeaveModelToJson(_LeaveModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'requestedById': instance.requestedById,
      'approvedById': instance.approvedById,
      'type': _$LeaveTypeEnumMap[instance.type]!,
      'reason': instance.reason,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$LeaveTypeEnumMap = {
  LeaveType.sick: 'sick',
  LeaveType.casual: 'casual',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.other: 'other',
};
