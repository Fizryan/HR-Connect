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

    // LeaveService Endpoints
    static String get leaveRequests => '$_baseApi/leave-requests';
    static String leaveRequest(String id) => '$_baseApi/leave-requests/$id';
    static String putLeaveRequest(String id) => '$_baseApi/leave-requests/$id';
    static String deleteLeaveRequest(String id) => '$_baseApi/leave-requests/$id';
}