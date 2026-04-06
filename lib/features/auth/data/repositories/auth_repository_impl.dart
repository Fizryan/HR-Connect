import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/core/network/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemote remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, void>> checkAuthStatus() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        return const Right(null);
      }
      return const Left(NetworkFailure('No token found'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    try {
      final authModel = await remoteDataSource.login(email, password);
      final token = authModel.token;

      if (token != null && token.isNotEmpty) {
        await secureStorage.write(key: 'auth_token', value: token);
      }

      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await secureStorage.delete(key: 'auth_token');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    try {
      final userProfile = await remoteDataSource.getUserProfile();
      return Right(userProfile);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
