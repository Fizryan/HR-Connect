import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:hr_connect/core/const/secure_storage.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemote remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AuthRepositoryImp({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.sharedPreferences,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, UserModel>> checkAuthStatus() async {
    try {
      final token = await secureStorage.read(key: SecureStorage.accessToken);
      if (token != null && token.isNotEmpty) {
        apiClient.updateToken(token);
        final cachedUser = sharedPreferences.getString('cachedUser');
        if (cachedUser != null) {
          final userMap = jsonDecode(cachedUser);
          return Right(UserModel.fromJson(userMap));
        }
        return await getUserInfo();
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
            'Failed to verify session. Please log in again.',
            name: 'failedVerifySession',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    try {
      final authModel = await remoteDataSource.login(email, password);
      return await authModel.when(
        success: (accessToken, expTime, refreshToken) async {
          await secureStorage.write(
            key: SecureStorage.accessToken,
            value: accessToken,
          );
          await secureStorage.write(
            key: SecureStorage.refreshToken,
            value: refreshToken,
          );
          apiClient.updateToken(accessToken);
          await getUserInfo();
          return const Right(null);
        },
        error: (message) async => Left(ServerFailure(message)),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[AuthRepository] Login Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'An unexpected error occurred while trying to log in.',
            name: 'unexpectedLoginError',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await secureStorage.read(
        key: SecureStorage.refreshToken,
      );
      if (refreshToken != null) {
        try {
          await remoteDataSource.logout(refreshToken);
        } catch (e) {
          debugPrint('[AuthRepository] API Logout failed (ignored): $e');
        }
      }

      await secureStorage.deleteAll();
      await sharedPreferences.remove('cachedUser');
      apiClient.clearToken();

      return const Right(null);
    } catch (e) {
      debugPrint('[AuthRepository] Local Logout Error: $e');
      return Left(
        CacheFailure(
          Intl.message(
            'An error occurred while trying to log out.',
            name: 'logoutError',
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
      if (currentRefreshToken == null || currentRefreshToken != token) {
        return Left(
          CacheFailure(
            Intl.message('Invalid refresh token', name: 'invalidRefreshToken'),
          ),
        );
      }

      final result = await remoteDataSource.refreshToken(currentRefreshToken);

      return await result.when(
        success: (accessToken, expTime, refreshToken) async {
          await secureStorage.write(
            key: SecureStorage.accessToken,
            value: accessToken,
          );
          apiClient.updateToken(accessToken);
          return const Right(null);
        },
        error: (message) async => Left(ServerFailure(message)),
      );
    } catch (e) {
      debugPrint('[AuthRepository] Refresh Token Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Session has expired. Please log in again.',
            name: 'sessionExpired',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    UserRole role,
  ) async {
    try {
      await remoteDataSource.register(
        email,
        password,
        firstName,
        lastName,
        role,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[AuthRepository] Register Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Registration failed. Please try again later.',
            name: 'registrationFailed',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserInfo() async {
    try {
      final user = await remoteDataSource.getUserInfo();
      final userMap = user.toJson();

      userMap.remove('password');

      await sharedPreferences.setString(
        'cachedUser',
        jsonEncode(userMap),
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[AuthRepository] Get User Info Error: $e');
      return Left(
        ServerFailure(
          Intl.message(
            'Failed to load user information.',
            name: 'loadUserInfoFailed',
          ),
        ),
      );
    }
  }
}
