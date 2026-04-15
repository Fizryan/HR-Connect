import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/testing/shared/user_data.dart';
import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

class UserDummyRemote implements UserRemote {
  final List<UserModel> _dummyUsers = UserData.dummyUsers.values.toList();

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
