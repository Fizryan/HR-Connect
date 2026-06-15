import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/config/date_utils.dart';
import 'package:hr_connect/core/constants/enum.dart';

part 'leave_model.freezed.dart';
part 'leave_model.g.dart';

@freezed
abstract class LeaveData with _$LeaveData {
  const factory LeaveData({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime startDate,
    @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime endDate,
  }) = _LeaveData;

  factory LeaveData.fromJson(Map<String, dynamic> json) =>
      _$LeaveDataFromJson(json);
}

@freezed
abstract class LeaveModel with _$LeaveModel {
  const factory LeaveModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'requesterId') required String requesterId,
    @JsonKey(name: 'data') required LeaveData data,
    @JsonKey(name: 'status') required RequestStatus status,
    @JsonKey(name: 'approverId') String? approverId,
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);
}
