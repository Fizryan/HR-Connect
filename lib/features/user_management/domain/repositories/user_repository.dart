import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserModel>>> getAllUsers();
  Future<Either<Failure, UserModel>> getUserByUid(String uid);
  Future<Either<Failure, UserModel>> createUser(UserModel user);
  Future<Either<Failure, UserModel>> updateUser(UserModel user);
  Future<Either<Failure, void>> deleteUser(String id);
}
