import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
abstract class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    @JsonKey(name: 'attendanceRate') required int attendanceRate,
    @JsonKey(name: 'pendingLeave') required int pendingLeave,
    @JsonKey(name: 'pendingTrip') required int pendingTrip,
    @JsonKey(name: 'totalUser') int? totalUser,
  }) = _DashboardModel;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
}
