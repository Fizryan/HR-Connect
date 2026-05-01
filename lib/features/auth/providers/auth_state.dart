import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated({String? message}) = _Unauthenticated;
}
