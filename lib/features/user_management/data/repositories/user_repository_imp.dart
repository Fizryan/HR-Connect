import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:intl/intl.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/datasource/user_remote.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository.dart';

class UserRepositoryImp implements UserRepository {
  final UserRemote remoteDataSource;

  UserRepositoryImp({required this.remoteDataSource});

  Future<Either<Failure, T>> _sourceCall<T>(
    Future<T> Function() call,
    String fallbackErrorMessage,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Error: $e');
      return Left(ServerFailure(fallbackErrorMessage));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    return _sourceCall(
      () => remoteDataSource.getUsers(page: page, limit: limit),
      Intl.message(
        'Failed to load users data. Please try again.',
        name: 'loadUserDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    return _sourceCall(
      () => remoteDataSource.getUserById(id),
      Intl.message(
        'Failed to load user data. Please try again.',
        name: 'loadUserDataFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _sourceCall(
      () => remoteDataSource.updateUser(id, updateData),
      Intl.message(
        'Failed to update user. Please try again.',
        name: 'updateUserFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> activateUser(String id) async {
    return _sourceCall(
      () => remoteDataSource.activateUser(id),
      Intl.message(
        'Failed to activate user. Please try again.',
        name: 'activateUserFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String id) async {
    return _sourceCall(
      () => remoteDataSource.deactivateUser(id),
      Intl.message(
        'Failed to deactivate user. Please try again.',
        name: 'deactivateUserFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    return _sourceCall(
      () => remoteDataSource.deleteUser(id),
      Intl.message(
        'Failed to delete user. Please try again.',
        name: 'deleteUserFailed',
      ),
    );
  }
}
