import 'package:freezed_annotation/freezed_annotation.dart';

enum UserRole {
  @JsonValue('admin')
  admin,

  @JsonValue('director')
  director,

  @JsonValue('manager')
  manager,

  @JsonValue('supervisor')
  supervisor,

  @JsonValue('staff')
  staff,
}