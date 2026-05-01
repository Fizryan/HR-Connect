import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/auth/providers/auth_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  
  @override
  AuthState build() {
    Future.microtask(checkAuth);
    
    return const AuthState.initial();
  }

  Future<void> checkAuth() async {
    state.maybeMap(
      initial: (_) => state = const AuthState.loading(),
      orElse: () {}, 
    );

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.checkAuthStatus();

    state = result.fold(
      (failure) => AuthState.unauthenticated(message: failure.message),
      AuthState.authenticated, 
    );
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(email, password);

    await result.fold(
      (failure) async {
        state = AuthState.unauthenticated(message: failure.message);
      },
      (_) async {
        await checkAuth();
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    state = const AuthState.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.register(
      email,
      password,
      firstName,
      lastName,
      role,
    );

    return result.fold(
      (failure) {
        state = AuthState.unauthenticated(message: failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated(
          message: 'Registration successful',
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    final repository = ref.read(authRepositoryProvider);
    await repository.logout();

    state = const AuthState.unauthenticated(message: 'Logged out successfully');
  }
}