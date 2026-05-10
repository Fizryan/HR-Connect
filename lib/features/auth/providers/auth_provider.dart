import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.checkAuthStatus();

    return result.fold((failure) => null, (user) => user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(email, password);

    state = await result.fold(
      (failure) async => AsyncValue.error(failure.message, StackTrace.current),
      (_) async {
        final authResult = await repository.checkAuthStatus();
        return authResult.fold(
          (failure) => AsyncValue.error(failure.message, StackTrace.current),
          AsyncValue.data,
        );
      },
    );
  }

  Future<void> register({
    String? avatarUrl,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.register(
      avatarUrl,
      email,
      password,
      firstName,
      lastName,
      role,
    );

    result.fold(
      (failure) => throw failure.message,
      (_) => null,
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(null);
  }
}
