import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserModel>>> getUsers({int page = 1, int limit = 20});
  Future<Either<Failure, UserModel>> getUserById(String id);
  Future<Either<Failure, UserModel>> updateUser(String id, Map<String, dynamic> updateData);
  Future<Either<Failure, void>> activateUser(String id);
  Future<Either<Failure, void>> deactivateUser(String id);
  Future<Either<Failure, void>> deleteUser(String id);
}