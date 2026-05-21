// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    _DashboardModel(
      attendanceRate: json['attendanceRate'] as num,
      pendingLeave: (json['pendingLeave'] as num).toInt(),
      pendingTrip: (json['pendingTrip'] as num).toInt(),
      totalUser: (json['totalUser'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardModelToJson(_DashboardModel instance) =>
    <String, dynamic>{
      'attendanceRate': instance.attendanceRate,
      'pendingLeave': instance.pendingLeave,
      'pendingTrip': instance.pendingTrip,
      'totalUser': instance.totalUser,
    };
