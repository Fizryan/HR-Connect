import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required String scannedAt,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}

@freezed
abstract class UserAttendanceModel with _$UserAttendanceModel {
  const factory UserAttendanceModel({
    required String userId,
    @Default([]) List<AttendanceModel> attendance,
  }) = _UserAttendanceModel;

  factory UserAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$UserAttendanceModelFromJson(json);
}

@freezed
abstract class AttendanceGenerateModel with _$AttendanceGenerateModel {
  const factory AttendanceGenerateModel({
    required String png,
    required String url,
  }) = _AttendanceGenerateModel;

  factory AttendanceGenerateModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceGenerateModelFromJson(json);
}
