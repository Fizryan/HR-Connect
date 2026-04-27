import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/logic/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/testing/shared/user_data.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';

class AuthDummyRemote implements AuthRemote {
  final Map<String, UserModel> dummyUsers = UserData.dummyUsers;
  String _currentUid = '';

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<AuthModel> login(String email, String password) async {
    await _simulatedNetworkDelay();
    
    final Map<String, Map<String, dynamic>> dummyAccounts = UserData.dummyAccounts;

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
