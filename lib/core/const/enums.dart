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

  @JsonValue('unknown')
  unknown,
}

enum LeaveType {
  @JsonValue('sick')
  sick,

  @JsonValue('casual')
  casual,

  @JsonValue('maternity')
  maternity,

  @JsonValue('paternity')
  paternity,

  @JsonValue('other')
  other,
}

enum BusinessTripType {
  @JsonValue('meeting')
  meeting,

  @JsonValue('travel')
  travel,

  @JsonValue('conference')
  conference,

  @JsonValue('seminar')
  seminar,

  @JsonValue('other')
  other,
}

enum RequestStatus {
  @JsonValue('pending')
  pending,

  @JsonValue('approved')
  approved,

  @JsonValue('rejected')
  rejected,
}
