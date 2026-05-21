import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> checkAuthStatus();
  Future<Either<Failure, void>> login(String email, String password);
  Future<Either<Failure, void>> register(
    String? avatarUrl,
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> refreshToken(String token);
  Future<Either<Failure, UserModel>> getUserInfo();
  Future<Either<Failure, void>> changePassword(String newPassword, String oldPassword);
  Future<Either<Failure, void>> resetPassword(String id, String newPassword);
}
