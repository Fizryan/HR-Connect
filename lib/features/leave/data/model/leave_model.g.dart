// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveData _$LeaveDataFromJson(Map<String, dynamic> json) => _LeaveData(
  type: json['type'] as String,
  description: json['description'] as String,
  startDate: ApiDateUtils.parseToDateTime(json['startDate']),
  endDate: ApiDateUtils.parseToDateTime(json['endDate']),
);

Map<String, dynamic> _$LeaveDataToJson(_LeaveData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

_LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => _LeaveModel(
  id: json['id'] as String,
  data: LeaveData.fromJson(json['data'] as Map<String, dynamic>),
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  requester: UserData.fromJson(json['requester'] as Map<String, dynamic>),
  approver: json['approver'] == null
      ? null
      : UserData.fromJson(json['approver'] as Map<String, dynamic>),
  rejectReason: json['rejectReason'] as String?,
);

Map<String, dynamic> _$LeaveModelToJson(_LeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'requester': instance.requester,
      'approver': instance.approver,
      'rejectReason': instance.rejectReason,
    };

const _$RequestStatusEnumMap = {
  RequestStatus.all: 'all',
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
};
