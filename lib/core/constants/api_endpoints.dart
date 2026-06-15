class ApiEndpoints {
  static const String _baseApi = '/api/v1';

  // AuthService Endpoints
  static String get authLogin => '$_baseApi/auth/login';
  static String get authLogout => '$_baseApi/auth/logout';
  static String get authRefresh => '$_baseApi/auth/refresh';
  static String get authReset => '$_baseApi/auth/reset';
  static String get authChange => '$_baseApi/auth/change';

  // UserService Endpoints
  static String get profile => '$_baseApi/me';
  static String get users => '$_baseApi/users';
  static String get usersRegister => '$_baseApi/users/register';
  static String getUser(String id) => '$_baseApi/users/$id';
  static String putUser(String id) => '$_baseApi/users/$id';
  static String deleteUser(String id) => '$_baseApi/users/$id';
  static String activateUser(String id) => '$_baseApi/users/$id/activate';
  static String deactivateUser(String id) => '$_baseApi/users/$id/deactivate';

  // LeaveService Endpoints
  static String get leaveMe => '$_baseApi/me/leave';
  static String get leavePendingMe => '$_baseApi/pending/leave';
  static String get leaveRequests => '$_baseApi/leave';
  static String get createLeaveRequest => '$_baseApi/leave/new';
  static String leaveRequest(String id) => '$_baseApi/leave/$id';
  static String putLeaveRequest(String id) => '$_baseApi/leave/$id';
  static String approveLeaveRequest(String id) => '$_baseApi/leave/$id/approve';
  static String rejectLeaveRequest(String id) => '$_baseApi/leave/$id/reject';

  // BusinessService Endpoints
  static String get businessTripMe => '$_baseApi/me/trip';
  static String get businessTripPendingMe => '$_baseApi/pending/trip';
  static String get businessTrips => '$_baseApi/trip';
  static String get createBusinessTrip => '$_baseApi/trip/new';
  static String businessTrip(String id) => '$_baseApi/trip/$id';
  static String putBusinessTrip(String id) => '$_baseApi/trip/$id';
  static String approveBusinessTrip(String id) => '$_baseApi/trip/$id/approve';
  static String rejectBusinessTrip(String id) => '$_baseApi/trip/$id/reject';

  // DashboardService Endpoints
  static String get dashboard => '$_baseApi/dashboard';

  // AttendanceService Endpoints
  static String get attendanceMe => '$_baseApi/attendance/me';
  static String get attendanceCheckIn => '$_baseApi/attendance/checkin';
  static String get attendanceCheckOut => '$_baseApi/attendance/checkout';
  static String get attendanceGenerate => '$_baseApi/attendance/generate';
  static String get attendance => '$_baseApi/attendance';
  static String attendanceById(String id) => '$_baseApi/attendance/$id';
}
