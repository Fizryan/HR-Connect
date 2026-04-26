import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

part 'leave_state.freezed.dart';

@freezed
class LeaveState with _$LeaveState {
  const factory LeaveState.initial() = _Initial;
  const factory LeaveState.loading() = _Loading;
  const factory LeaveState.dataList(List<LeaveModel> leaves) = _DataList;
  const factory LeaveState.data(LeaveModel leave) = _Data;
  const factory LeaveState.success(String message) = _Success;
  const factory LeaveState.error(String message) = _Error;
}