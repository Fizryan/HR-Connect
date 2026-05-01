import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._(); 

  const factory UserModel({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive, 
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
      
  String get fullName => '$firstName $lastName';
}