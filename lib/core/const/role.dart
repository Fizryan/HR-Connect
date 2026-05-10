import 'package:hr_connect/core/const/enums.dart';

class Role {
  static UserRole rawToRole(String rawRole) {
    switch (rawRole) {
      case 'ROLE_ADMIN':
        return UserRole.admin;
      case 'ROLE_DIRECTOR':
        return UserRole.director;
      case 'ROLE_MANAGER':
        return UserRole.manager;
      case 'ROLE_SUPERVISOR':
        return UserRole.supervisor;
      case 'ROLE_STAFF_UNSPECIFIED':
        return UserRole.staff;
      default:
        return UserRole.unknown;
    }
  }

  static String roleToRaw(UserRole role) {
    String mappedRole = 'unknown';
    switch (role) {
      case UserRole.admin:
        mappedRole = 'ROLE_ADMIN';
        return mappedRole;
      case UserRole.director:
        mappedRole = 'ROLE_DIRECTOR';
        return mappedRole;
      case UserRole.manager:
        mappedRole = 'ROLE_MANAGER';
        return mappedRole;
      case UserRole.supervisor:
        mappedRole = 'ROLE_SUPERVISOR';
        return mappedRole;
      case UserRole.staff:
        mappedRole = 'ROLE_STAFF_UNSPECIFIED';
        return mappedRole;
      default:
        mappedRole = 'ROLE_UNKNOWN';
        return mappedRole;
    }
  }
}
