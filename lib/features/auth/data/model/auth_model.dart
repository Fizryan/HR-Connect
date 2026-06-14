import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/config/date_utils.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthModel with _$AuthModel {
  const factory AuthModel.success({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'refreshToken') required String refreshToken,
    @JsonKey(name: 'expTime', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime expTime,
  }) = _AuthSuccess;

  const factory AuthModel.error({required String message}) = _AuthError;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}
