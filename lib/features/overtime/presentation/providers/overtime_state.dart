import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/overtime/data/models/overtime_model.dart';

part 'overtime_state.freezed.dart';

@freezed
class OvertimeState with _$OvertimeState {
  const factory OvertimeState.initial() = _Initial;
  const factory OvertimeState.loading() = _Loading;
  const factory OvertimeState.dataList(List<OvertimeModel> overtimes) =
      _DataList;
  const factory OvertimeState.data(OvertimeModel overtime) = _Data;
  const factory OvertimeState.success(String message) = _Success;
  const factory OvertimeState.error(String message) = _Error;
}
