// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveRequestModel _$LeaveRequestModelFromJson(Map<String, dynamic> json) =>
    _LeaveRequestModel(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      description: json['description'] as String?,
      approverId: json['approverId'] as String?,
      status:
          $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.pending,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LeaveRequestModelToJson(_LeaveRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
      'description': instance.description,
      'approverId': instance.approverId,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LeaveTypeEnumMap = {
  LeaveType.sick: 'sick',
  LeaveType.casual: 'casual',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.other: 'other',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
};
