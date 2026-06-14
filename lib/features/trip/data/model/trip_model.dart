import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/config/date_utils.dart';
import 'package:hr_connect/core/constants/enum.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
abstract class TripData with _$TripData {
  const factory TripData({
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'startDate', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime startDate,
    @JsonKey(name: 'endDate', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime endDate,
  }) = _TripData;

  factory TripData.fromJson(Map<String, dynamic> json) =>
      _$TripDataFromJson(json);
}

@freezed
abstract class TripModel with _$TripModel {
  const factory TripModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'requesterId') required String requesterId,
    @JsonKey(name: 'data') required TripData data,
    @JsonKey(name: 'status') required RequestStatus status,
    @JsonKey(name: 'approverId') String? approverId,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);
}
