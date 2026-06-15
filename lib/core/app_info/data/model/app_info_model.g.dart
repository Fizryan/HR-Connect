// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppInfoModel _$AppInfoModelFromJson(Map<String, dynamic> json) =>
    _AppInfoModel(
      appName: json['appName'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',
      version: json['version'] as String? ?? '',
      buildNumber: json['buildNumber'] as String? ?? '',
    );

Map<String, dynamic> _$AppInfoModelToJson(_AppInfoModel instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'packageName': instance.packageName,
      'version': instance.version,
      'buildNumber': instance.buildNumber,
    };
