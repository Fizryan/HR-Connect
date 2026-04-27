import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<AccountModel>>> getAllAccounts();
  Future<Either<Failure, AccountModel>> getAccountById(String uid);
  Future<Either<Failure, AccountModel>> createAccount(AccountModel account);
  Future<Either<Failure, AccountModel>> updateAccount(AccountModel account);
  Future<Either<Failure, void>> deleteAccount(String uid);
}