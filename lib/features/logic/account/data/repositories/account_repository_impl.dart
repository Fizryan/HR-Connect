import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/account/data/datasource/account_remote.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/data/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemote remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AccountModel>>> getAllAccounts() async {
    try {
      final result = await remoteDataSource.getAllAccounts();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountModel>> getAccountById(String uid) async {
    try {
      final result = await remoteDataSource.getAccountById(uid);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountModel>> createAccount(AccountModel account) async {
    try {
      final result = await remoteDataSource.createAccount(account);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountModel>> updateAccount(AccountModel account) async {
    try {
      final result = await remoteDataSource.updateAccount(account.uid, account.toJson());
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String uid) async {
    try {
      await remoteDataSource.deleteAccount(uid);
      return const Right(null);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }
}