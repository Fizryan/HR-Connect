import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

class AuthDummyRemote implements AuthRemote {
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
    
    final Map<String, UserModel> dummyUsers = {
      'USR-001': UserModel(
        uid: 'USR-001',
        firstName: 'Hafizryandin',
        lastName: 'Haykal Matondang',
        role: UserRole.admin,
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      'USR-002': UserModel(
        uid: 'USR-002',
        firstName: 'Muhammad Fathir',
        lastName: 'Rizky Salam',
        role: UserRole.director,
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      'USR-003': UserModel(
        uid: 'USR-003',
        firstName: 'Hafidz Naufal',
        lastName: 'Pradana',
        role: UserRole.manager,
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      'USR-004': UserModel(
        uid: 'USR-004',
        firstName: 'Haidar Zahran',
        lastName: 'Haryono',
        role: UserRole.supervisor,
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        updatedAt: DateTime.now().subtract(const Duration(days: 11)),
      ),
      'USR-005': UserModel(
        uid: 'USR-005',
        firstName: 'Cecep Wijaya',
        lastName: 'Antonio Lopez',
        role: UserRole.staff,
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    };

    if (dummyUsers.containsKey(_currentUid)) {
      return dummyUsers[_currentUid]!;
    }
    
    throw const ServerFailure('User profile not found.');
  }
}
