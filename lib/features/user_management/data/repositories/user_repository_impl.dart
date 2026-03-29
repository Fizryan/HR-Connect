import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/user_management/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemote remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final result = await remoteDataSource.getAllUsers();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserByUid(String uid) async {
    try {
      final result = await remoteDataSource.getUserByUid(uid);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUser(UserModel user) async {
    try {
      final result = await remoteDataSource.createUser(user.toJson());
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    try {
      final result = await remoteDataSource.updateUser(user.uid, user.toJson());
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String uid) async {
    try {
      await remoteDataSource.deleteUser(uid);
      return const Right(null);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }
}
