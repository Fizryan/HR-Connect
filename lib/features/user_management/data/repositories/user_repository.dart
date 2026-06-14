import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUserInfo();
  Future<Either<Failure, List<UserModel>>> getAllUsers();
  Future<Either<Failure, UserModel>> getUserById(String id);
  Future<Either<Failure, void>> registerUser(UserData data, String password);
  Future<Either<Failure, void>> updateUser(String id, UserData data);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, void>> activateUser(String id);
  Future<Either<Failure, void>> deactivateUser(String id);
}
