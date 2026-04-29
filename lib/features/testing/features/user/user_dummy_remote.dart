import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/testing/shared/dummy_database.dart';
import 'package:hr_connect/features/logic/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';

class UserDummyRemote implements UserRemote {

  Future<void> _simulatedNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    await _simulatedNetworkDelay();
    return List.unmodifiable(DummyDatabase.users);
  }

  @override
  Future<UserModel> getUserByUid(String uid) async {
    await _simulatedNetworkDelay();
    try {
      return DummyDatabase.users.firstWhere((user) => user.uid == uid);
    } catch (e) {
      throw const ServerFailure('User not found');
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    await _simulatedNetworkDelay();

    try {
      final newData = Map<String, dynamic>.from(userData);
      
      // Gunakan uid yang dikirimkan UI (dari dropdown unassigned account),
      // jika kosong, baru generate uid baru.
      if (newData['uid'] == null || newData['uid'].toString().isEmpty) {
        newData['uid'] = 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      }
      
      if (newData['createdAt'] == null) {
        newData['createdAt'] = DateTime.now().toIso8601String();
      }

      final newUser = UserModel.fromJson(newData);
      DummyDatabase.users.add(newUser);

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

    final userIndex = DummyDatabase.users.indexWhere((user) => user.uid == uid);

    if (userIndex == -1) {
      throw const ServerFailure('User not found');
    }

    try {
      final oldUser = DummyDatabase.users[userIndex];
      final Map<String, dynamic> updatedJson = {
        ...oldUser.toJson(),
        ...userData,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final updateUser = UserModel.fromJson(updatedJson);
      DummyDatabase.users[userIndex] = updateUser;

      return updateUser;
    } catch (e) {
      throw const ServerFailure('Failed to update user');
    }
  }

  @override
  Future<void> deleteUser(String uid) async {
    await _simulatedNetworkDelay();

    final initialLength = DummyDatabase.users.length;
    DummyDatabase.users.removeWhere((user) => user.uid == uid);

    if (DummyDatabase.users.length == initialLength) {
      throw const ServerFailure('User not found');
    }
  }
}
