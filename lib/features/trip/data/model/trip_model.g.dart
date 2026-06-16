// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripData _$TripDataFromJson(Map<String, dynamic> json) => _TripData(
  type: json['type'] as String,
  description: json['description'] as String,
  startDate: ApiDateUtils.parseToDateTime(json['startDate']),
  endDate: ApiDateUtils.parseToDateTime(json['endDate']),
);

Map<String, dynamic> _$TripDataToJson(_TripData instance) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
};

_TripModel _$TripModelFromJson(Map<String, dynamic> json) => _TripModel(
  id: json['id'] as String,
  data: TripData.fromJson(json['data'] as Map<String, dynamic>),
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  requester: UserData.fromJson(json['requester'] as Map<String, dynamic>),
  approver: json['approver'] == null
      ? null
      : UserData.fromJson(json['approver'] as Map<String, dynamic>),
  rejectReason: json['rejectReason'] as String?,
);

Map<String, dynamic> _$TripModelToJson(_TripModel instance) =>
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
