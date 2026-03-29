import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/user_management/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemote remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final user = await remoteDataSource.getUsers();
      return Right(user);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        return Left(e as Failure);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
