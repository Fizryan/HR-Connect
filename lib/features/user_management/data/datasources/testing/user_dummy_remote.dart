import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

class UserDummyRemote implements UserRemote {
  final List<UserModel> _dummyUsers = [
    UserModel(
      uid: 'USR-001',
      firstName: 'Hafizryandin',
      lastName: 'Haykal Matondang',
      role: UserRole.admin,
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    UserModel(
      uid: 'USR-002',
      firstName: 'Muhammad Fathir',
      lastName: 'Rizky Salam',
      role: UserRole.director,
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 22)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    UserModel(
      uid: 'USR-003',
      firstName: 'Hafidz Naufal',
      lastName: 'Pradana',
      role: UserRole.manager,
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    UserModel(
      uid: 'USR-004',
      firstName: 'Haidar Zahran',
      lastName: 'Haryono',
      role: UserRole.supervisor,
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      updatedAt: DateTime.now().subtract(const Duration(days: 11)),
    ),
    UserModel(
      uid: 'USR-005',
      firstName: 'Cecep Wijaya',
      lastName: 'Antonio Lopez',
      role: UserRole.staff,
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    await _simulatedNetworkDelay();
    return List.unmodifiable(_dummyUsers);
  }

  @override
  Future<UserModel> getUserByUid(String uid) async {
    await _simulatedNetworkDelay();
    try {
      return _dummyUsers.firstWhere((user) => user.uid == uid);
    } catch (e) {
      throw const ServerFailure('User not found');
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    await _simulatedNetworkDelay();

    try {
      final newUid =
          'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      final newData = Map<String, dynamic>.from(userData);
      newData['uid'] = newUid;
      newData['createdAt'] = DateTime.now().toIso8601String();

      final newUser = UserModel.fromJson(newData);
      _dummyUsers.add(newUser);

      return newUser;
    } catch (e) {
      throw const ServerFailure('Failed to create user');
    }
  }

  @override
  Future<UserModel> updateUser(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    await _simulatedNetworkDelay();

    final userIndex = _dummyUsers.indexWhere((user) => user.uid == uid);

    if (userIndex == -1) {
      throw const ServerFailure('User not found');
    }

    try {
      final oldUser = _dummyUsers[userIndex];
      final Map<String, dynamic> updatedJson = {
        ...oldUser.toJson(),
        ...userData,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final updateUser = UserModel.fromJson(updatedJson);
      _dummyUsers[userIndex] = updateUser;

      return updateUser;
    } catch (e) {
      throw const ServerFailure('Failed to update user');
    }
  }

  @override
  Future<void> deleteUser(String uid) async {
    await _simulatedNetworkDelay();

    final initialLength = _dummyUsers.length;
    _dummyUsers.removeWhere((user) => user.uid == uid);

    if (_dummyUsers.length == initialLength) {
      throw const ServerFailure('User not found');
    }
  }
}
