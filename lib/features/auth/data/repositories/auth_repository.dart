import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkAuthStatus();
  Future<Either<Failure, void>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> refreshToken(String token);
  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String oldPassword,
  );
  Future<Either<Failure, void>> resetPassword(String id, String newPassword);
}
