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

  @override
  Future<Either<Failure, List<UserModel>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final users = await remoteDataSource.getUsers(page: page, limit: limit);
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Get Users Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'An unexpected system error occurred. Please try again later.',
            name: 'unexpectedSystemError',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Get User By ID Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to load user data. Please try again.',
            name: 'loadUserDataFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final updateUser = await remoteDataSource.updateUser(id, updateData);
      return Right(updateUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Update User Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to update user data. Please check again.',
            name: 'updateUserDataFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> activateUser(String id) async {
    try {
      await remoteDataSource.activateUser(id);
      return const Right(null);
    } catch (e) {
      debugPrint('[UserRepository] Activate User Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to activate user. Please try again.',
            name: 'activateUserFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String id) async {
    try {
      await remoteDataSource.deactivateUser(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Deactivate User Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to deactivate user. Please try again.',
            name: 'deactivateUserFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await remoteDataSource.deleteUser(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[UserRepository] Delete User Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to delete user. Please try again.',
            name: 'deleteUserFailed',
          ),
        ),
      );
    }
  }
}
