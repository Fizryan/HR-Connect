import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/data/remote/user_remote.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImp extends BaseRepository implements UserRepository {
  final UserRemote remoteDataSource;
  final SharedPreferences sharedPreferences;

  UserRepositoryImp({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, UserModel>> getUserInfo() async {
    final apiResult = await sourceCall(
      () async {
        final user = await remoteDataSource.getUserInfo();
        final userMap = user.toJson();
        await sharedPreferences.setString(
          SharedPrefs.cachedUser,
          jsonEncode(userMap),
        );

        return user;
      },
      Intl.message(
        'Failed to load user information.',
        name: 'loadUserInfoFailed',
      ),
    );

    return apiResult.fold(
      (failure) {
        logger.e('[UserRepository] API call failed, loading from cache.');
        final cachedData = sharedPreferences.getString(SharedPrefs.cachedUser);

        if (cachedData != null && cachedData.isNotEmpty) {
          final userMap = jsonDecode(cachedData) as Map<String, dynamic>;
          return Right(UserModel.fromJson(userMap));
        }

        return Left(failure);
      },
      (user) {
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, void>> activateUser(String id) async {
    return sourceCall(
      () => remoteDataSource.activateUser(id),
      Intl.message('Failed to activate user.', name: 'activateUserFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String id) async {
    return sourceCall(
      () => remoteDataSource.deactivateUser(id),
      Intl.message('Failed to deactivate user.', name: 'deactivateUserFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    return sourceCall(
      () => remoteDataSource.deleteUser(id),
      Intl.message('Failed to delete user.', name: 'deleteUserFailed'),
    );
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    return sourceCall(
      remoteDataSource.getAllUsers,
      Intl.message('Failed to load users.', name: 'loadUsersFailed'),
    );
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    return sourceCall(
      () => remoteDataSource.getUserById(id),
      Intl.message('Failed to load user.', name: 'loadUserFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> registerUser(
    UserData data,
    String password,
  ) async {
    return sourceCall(
      () => remoteDataSource.registerUser(data, password),
      Intl.message('Failed to register user.', name: 'registerUserFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> updateUser(String id, UserData data) async {
    return sourceCall(
      () => remoteDataSource.updateUser(id, data),
      Intl.message('Failed to update user.', name: 'updateUserFailed'),
    );
  }
}
