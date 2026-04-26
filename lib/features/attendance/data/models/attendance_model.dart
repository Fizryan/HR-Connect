import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required String uid,
    required String requestedById,
    @JsonKey(name: 'login_time') DateTime? loginTme,
    @JsonKey(name: 'logout_time') DateTime? logoutTime,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}
