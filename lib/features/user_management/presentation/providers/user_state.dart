import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.dataList(List<UserModel> users) = _DataList;
  const factory UserState.data(UserModel user) = _Data;
  const factory UserState.success(String message) = _Success;
  const factory UserState.error(String message) = _Error;
}
