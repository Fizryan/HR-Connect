import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/logic/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/testing/shared/dummy_database.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';

class AuthDummyRemote implements AuthRemote {
  String _currentUid = '';

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<AuthModel> login(String email, String password) async {
    await _simulatedNetworkDelay();
    
    AccountModel? accountInfo;
    try {
      accountInfo = DummyDatabase.accounts.firstWhere(
        (acc) => acc.email == email,
      );
    } catch (_) {
      throw const ServerFailure('Invalid email or password. Please try again.');
    }

    if (password == accountInfo.password) {
      _currentUid = accountInfo.uid;
      
      try {
        final user = DummyDatabase.users.firstWhere((u) => u.uid == _currentUid);
        
        if (!user.isActive) {
          throw const ServerFailure('This account is deactivated.');
        }
        
        return AuthModel(
          token: 'dummy_${user.role.name}_token_abcdef1234567890',
          message: 'Login successful',
        );
      } on ServerFailure {
        rethrow;
      } catch (_) {
        throw const ServerFailure('User profile not found. Please ask admin to assign a user to this account.');
      }
    }

    throw const ServerFailure('Invalid email or password. Please try again.');
  }

  @override
  Future<UserModel> getUserProfile() async {
    await _simulatedNetworkDelay();

    try {
      return DummyDatabase.users.firstWhere((u) => u.uid == _currentUid);
    } catch (_) {
      throw const ServerFailure('User profile not found.');
    }
  }
}
