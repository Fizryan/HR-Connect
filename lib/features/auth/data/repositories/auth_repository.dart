import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> checkAuthStatus();
  Future<Either<Failure, void>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserModel>> getUserProfile();
}