import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUserData();
}
