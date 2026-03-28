import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/data/datasources/auth_remote.dart';
import 'package:hr_connect/features/auth/data/models/user_model.dart';
import 'package:hr_connect/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemote remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      return Right(user);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        return Left(e as Failure);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
