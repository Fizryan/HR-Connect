import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/dashboard/providers/dashboard_providers.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    return _fetchUser();
  }

  Future<UserModel?> _fetchUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final authResult = await authRepository.checkAuthStatus();

    return authResult.fold((failure) => null, (isLoggedIn) async {
      if (isLoggedIn) {
        final userResult = await userRepository.getUserInfo();
        return userResult.fold((failure) => null, (user) => user);
      }
      return null;
    });
  }

  void updateCurrentUser(UserModel user) {
    if (state.hasValue && state.value?.id == user.id) {
      state = AsyncValue.data(user);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final userRepository = ref.read(userRepositoryProvider);

      final loginResult = await authRepository.login(email, password);

      loginResult.fold(
        (failure) => throw Exception(failure.message),
        (_) => null,
      );

      final userResult = await userRepository.getUserInfo();

      return userResult.fold(
        (failure) => throw Exception(failure.message),
        (user) => user,
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.logout();

    ref.invalidate(dashboardNotifierProvider);
    ref.invalidate(leaveMeProvider);
    ref.invalidate(tripMeProvider);
    ref.invalidate(userNotifierProvider);

    ref.read(apiClientProvider).clearMemoryCache();

    final cacheManager = ref.read(cacheManagerProvider);
    await cacheManager.clearAllUserData();

    state = const AsyncValue.data(null);
  }

  Future<Either<Failure, void>> changePassword(
    String newPassword,
    String oldPassword,
  ) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.changePassword(newPassword, oldPassword);
  }

  Future<void> resetPassword(String id, String newPassword) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.resetPassword(id, newPassword);
    result.fold((failure) => throw Exception(failure.message), (_) => null);
  }
}
