import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
abstract class AttendanceData with _$AttendanceData {
  const factory AttendanceData({
    @JsonKey(name: 'checkInAt') required String checkInAt,
    @JsonKey(name: 'checkOutAt') required String checkOutAt,
    @JsonKey(name: 'workday') required String workday,
  }) = _AttendanceData;

  factory AttendanceData.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDataFromJson(json);
}

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'attendance') required List<AttendanceData> attendance,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}
