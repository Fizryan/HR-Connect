import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/config/date_utils.dart';
import 'package:hr_connect/core/constants/enum.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'firstName') required String firstName,
    @JsonKey(name: 'lastName') required String lastName,
    @JsonKey(name: 'role', unknownEnumValue: Role.unknown) required Role role,
    @JsonKey(name: 'avatarUrl') String? avatarUrl,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'data') required UserData data,
    @JsonKey(name: 'isActive') required bool isActive,
    @JsonKey(name: 'createdAt', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime createdAt,
    @JsonKey(name: 'updatedAt', fromJson: ApiDateUtils.parseToDateTime)
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
