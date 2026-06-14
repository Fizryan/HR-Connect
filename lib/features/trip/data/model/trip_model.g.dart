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
  requesterId: json['requesterId'] as String,
  data: TripData.fromJson(json['data'] as Map<String, dynamic>),
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  approverId: json['approverId'] as String?,
);

Map<String, dynamic> _$TripModelToJson(_TripModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'data': instance.data,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'approverId': instance.approverId,
    };

const _$RequestStatusEnumMap = {
  RequestStatus.all: 'all',
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
};
