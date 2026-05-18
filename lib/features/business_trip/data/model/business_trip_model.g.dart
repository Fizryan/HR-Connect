// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessTripModel _$BusinessTripModelFromJson(Map<String, dynamic> json) =>
    _BusinessTripModel(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      businessTripType: $enumDecode(
        _$BusinessTripTypeEnumMap,
        json['businessTripType'],
      ),
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

Map<String, dynamic> _$BusinessTripModelToJson(_BusinessTripModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'businessTripType': _$BusinessTripTypeEnumMap[instance.businessTripType]!,
      'description': instance.description,
      'approverId': instance.approverId,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BusinessTripTypeEnumMap = {
  BusinessTripType.meeting: 'meeting',
  BusinessTripType.travel: 'travel',
  BusinessTripType.conference: 'conference',
  BusinessTripType.seminar: 'seminar',
  BusinessTripType.other: 'other',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
};
