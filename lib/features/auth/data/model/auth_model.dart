import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthModel with _$AuthModel {
  const factory AuthModel.success({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'expTime') required String expTime,
    @JsonKey(name: 'refreshToken') required String refreshToken,
  }) = _AuthSuccess;

  const factory AuthModel.error({
    required String message,
  }) = _AuthError;
  
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}
