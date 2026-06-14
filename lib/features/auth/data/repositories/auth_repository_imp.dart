import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/constants/secure_storage.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/auth/data/remote/auth_remote.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:intl/intl.dart';

class AuthRepositoryImp extends BaseRepository implements AuthRepository {
  final AuthRemote remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final _logger = LoggerConfig.logger;

  AuthRepositoryImp({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final token = await secureStorage.read(key: SecureStorage.accessToken);
      if (token != null && token.isNotEmpty) {
        remoteDataSource.updateToken(token);
        return const Right(true);
      }
      return Left(
        CacheFailure(
          Intl.message(
            'No token found, please login again.',
            name: 'noTokenFound',
          ),
        ),
      );
    } catch (e) {
      return Left(
        CacheFailure(
          Intl.message(
            'Failed to verify session, Please log in again.',
            name: 'failedVerifySession',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    return sourceCall(
      () async {
        final authModel = await remoteDataSource.login(email, password);
        await authModel.when(
          success: (accessToken, refreshToken, expTime) async {
            await secureStorage.write(
              key: SecureStorage.accessToken,
              value: accessToken,
            );
            await secureStorage.write(
              key: SecureStorage.refreshToken,
              value: refreshToken,
            );
            remoteDataSource.updateToken(accessToken);
          },
          error: (message) => throw ServerException(message: message),
        );
      },
      Intl.message(
        'An unexpected error occurred while trying to login.',
        name: 'unexpectedLoginError',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await secureStorage.read(
        key: SecureStorage.refreshToken,
      );
      if (refreshToken != null) {
        try {
          await remoteDataSource.logout();
        } catch (e, stackTrace) {
          _logger.e(
            '[AuthRepository] API logout failed',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
      await secureStorage.deleteAll();
      remoteDataSource.clearToken();

      return const Right(null);
    } catch (e, stackTrace) {
      _logger.e(
        '[AuthRepository] Local logout error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        CacheFailure(
          Intl.message(
            'An error occured while trying to logout.',
            name: 'unexpectedLogoutError',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken(String token) async {
    try {
      final currentRefreshToken = await secureStorage.read(
        key: SecureStorage.refreshToken,
      );
      if (currentRefreshToken == null ||
          currentRefreshToken.isEmpty ||
          currentRefreshToken != token) {
        return Left(
          CacheFailure(
            Intl.message('Invalid refresh token', name: 'invalidRefreshToken'),
          ),
        );
      }

      return await sourceCall(
        () async {
          final result = await remoteDataSource.refreshToken(
            currentRefreshToken,
          );
          await result.when(
            success: (accessToken, refreshToken, expTime) async {
              await secureStorage.write(
                key: SecureStorage.accessToken,
                value: accessToken,
              );
              await secureStorage.write(
                key: SecureStorage.refreshToken,
                value: refreshToken,
              );
              remoteDataSource.updateToken(accessToken);
            },
            error: (message) => throw ServerException(message: message),
          );
        },
        Intl.message(
          'Session has expired. Please login again.',
          name: 'sessionExpired',
        ),
      );
    } catch (e, stackTrace) {
      _logger.e(
        '[AuthRepository] Refresh token error',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ServerFailure(
          Intl.message(
            'Session has expired, please login again.',
            name: 'sessionExpired',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String oldPassword,
  ) async {
    return sourceCall(
      () async =>
          await remoteDataSource.changePassword(newPassword, oldPassword),
      Intl.message('Failed to change password.', name: 'changePasswordFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String id,
    String newPassword,
  ) async {
    return sourceCall(
      () async => await remoteDataSource.resetPassword(id, newPassword),
      Intl.message('Failed to reset password.', name: 'resetPasswordFailed'),
    );
  }
}
