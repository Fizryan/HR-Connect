import 'package:freezed_annotation/freezed_annotation.dart';

enum Role {
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

enum RequestKind {
  @JsonValue('leave')
  leave,
  @JsonValue('trip')
  trip,
}

enum RequestStatus {
  @JsonValue('all')
  all,
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
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

enum TripType {
  @JsonValue('meeting')
  meeting,
  @JsonValue('conference')
  conference,
  @JsonValue('travel')
  travel,
  @JsonValue('seminar')
  seminar,
  @JsonValue('other')
  other,
}

enum QrType {
  @JsonValue('checkin')
  checkin,
  @JsonValue('checkout')
  checkout,
}
