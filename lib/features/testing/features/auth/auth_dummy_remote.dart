import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/testing/shared/user_data.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

class AuthDummyRemote implements AuthRemote {
  final Map<String, UserModel> dummyUsers = UserData.dummyUsers;
  String _currentUid = 'USR-005';

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<AuthModel> login(String email, String password) async {
    await _simulatedNetworkDelay();

    final Map<String, Map<String, dynamic>> dummyAccounts = {
      'admin@hrconnect.com': { 'role': UserRole.admin, 'uid': 'USR-001' },
      'director@hrconnect.com': { 'role': UserRole.director, 'uid': 'USR-002' },
      'manager@hrconnect.com': { 'role': UserRole.manager, 'uid': 'USR-003' },
      'supervisor@hrconnect.com': { 'role': UserRole.supervisor, 'uid': 'USR-004' },
      'staff@hrconnect.com': { 'role': UserRole.staff, 'uid': 'USR-005' },
      'test@hrconnect.com': { 'role': UserRole.staff, 'uid': 'USR-006' },
    };

    if (dummyAccounts.containsKey(email)) {
      final accountInfo = dummyAccounts[email]!;
      final UserRole role = accountInfo['role'];
      final expectedPassword = '${role.name}123';
      
      if (password == expectedPassword) {
        _currentUid = accountInfo['uid'];
        return AuthModel(
          token: 'dummy_${role.name}_token_abcdef1234567890',
          message: 'Login successful',
        );
      }
    }

    throw const ServerFailure('Invalid email or password. Please try again.');
  }

  @override
  Future<UserModel> getUserProfile() async {
    await _simulatedNetworkDelay();

    if (dummyUsers.containsKey(_currentUid)) {
      return dummyUsers[_currentUid]!;
    }
    
    throw const ServerFailure('User profile not found.');
  }
}
