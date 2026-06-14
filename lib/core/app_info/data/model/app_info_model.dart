import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info_model.freezed.dart';
part 'app_info_model.g.dart';

@freezed
abstract class AppInfoModel with _$AppInfoModel {
  const factory AppInfoModel({
    @Default('') String appName,
    @Default('') String packageName,
    @Default('') String version,
    @Default('') String buildNumber,
  }) = _AppInfoModel;

  factory AppInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AppInfoModelFromJson(json);
}
