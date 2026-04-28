import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
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
    
    final Map<String, AccountModel> dummyAccounts = UserData.dummyAccounts;

    if (dummyAccounts.containsKey(email)) {
      final accountInfo = dummyAccounts[email]!;
      final expectedPassword = accountInfo.password;

      if (password == expectedPassword) {
        _currentUid = accountInfo.uid;
        
        final user = dummyUsers[_currentUid];
        final roleName = user?.role.name ?? 'unknown';
        
        return AuthModel(
          token: 'dummy_${roleName}_token_abcdef1234567890',
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
