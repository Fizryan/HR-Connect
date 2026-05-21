import 'package:hr_connect/core/const/enums.dart';

class Role {
  static UserRole rawToRole(String rawRole) {
    switch (rawRole.toLowerCase()) {
      case 'admin':
      case 'role_admin':
        return UserRole.admin;
      case 'director':
      case 'role_director':
        return UserRole.director;
      case 'manager':
      case 'role_manager':
        return UserRole.manager;
      case 'supervisor':
      case 'role_supervisor':
        return UserRole.supervisor;
      case 'staff':
      case 'role_staff_unspecified':
      case 'role_staff':
        return UserRole.staff;
      default:
        return UserRole.unknown;
    }
  }

  static String roleToRaw(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.director:
        return 'director';
      case UserRole.manager:
        return 'manager';
      case UserRole.supervisor:
        return 'supervisor';
      case UserRole.staff:
        return 'staff';
      default:
        return 'unknown';
    }
  }
}
