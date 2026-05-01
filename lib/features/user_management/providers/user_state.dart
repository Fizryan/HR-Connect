import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(List<UserModel> users) = _Loaded;
  const factory UserState.error(String message) = _Error;
}