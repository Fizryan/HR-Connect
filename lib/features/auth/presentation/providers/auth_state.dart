import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/auth/data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.data(UserModel user) = _Data;
  const factory AuthState.error(String message) = _Error;
}
