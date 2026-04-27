import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/logic/attendance/data/models/attendance_model.dart';

part 'attendance_state.freezed.dart';

@freezed
class AttendanceState with _$AttendanceState {
  const factory AttendanceState.initial() = _Initial;
  const factory AttendanceState.loading() = _Loading;
  const factory AttendanceState.dataList(List<AttendanceModel> attendances) =
      _DataList;
  const factory AttendanceState.data(AttendanceModel attendance) = _Data;
  const factory AttendanceState.success(String message) = _Success;
  const factory AttendanceState.error(String message) = _Error;
}
