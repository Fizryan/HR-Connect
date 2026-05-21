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
    static String get leaveRequests => '$_baseApi/leavereqs';
    static String leaveRequest(String id) => '$_baseApi/leavereqs/$id';
    static String putLeaveRequest(String id) => '$_baseApi/leavereqs/$id';
    static String deleteLeaveRequest(String id) => '$_baseApi/leavereqs/$id';
    static String approveLeaveRequest(String id) => '$_baseApi/leavereqs/$id/approve';
    static String rejectLeaveRequest(String id) => '$_baseApi/leavereqs/$id/reject';

    // BusinessService Endpoints
    static String get businessTrips => '$_baseApi/businesstrips';
    static String businessTrip(String id) => '$_baseApi/businesstrips/$id';
    static String putBusinessTrip(String id) => '$_baseApi/businesstrips/$id';
    static String deleteBusinessTrip(String id) => '$_baseApi/businesstrips/$id';
    static String approveBusinessTrip(String id) => '$_baseApi/businesstrips/$id/approve';
    static String rejectBusinessTrip(String id) => '$_baseApi/businesstrips/$id/reject';

    // DashboardService Endpoints
    static String get dashboard => '$_baseApi/dashboard';
}