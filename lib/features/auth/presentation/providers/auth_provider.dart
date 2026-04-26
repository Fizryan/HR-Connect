import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_state.dart';

class AuthProvider extends ValueNotifier<AuthState> {
  final AuthRepository repository;
  final FlutterSecureStorage secureStorage;

  AuthProvider({required this.repository, required this.secureStorage})
    : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    value = const AuthState.loading();
    final result = await repository.checkAuthStatus();
    await result.fold(
      (failure) async => value = AuthState.error(failure.message),
      (_) async => await _fetchAndSetUser(),
    );
  }

  Future<void> login(String email, String password) async {
    value = const AuthState.loading();
    final result = await repository.login(email, password);
    await result.fold(
      (failure) async => value = AuthState.error(failure.message),
      (_) async => await _fetchAndSetUser(),
    );
  }

  Future<void> logout() async {
    value = const AuthState.loading();
    final result = await repository.logout();
    result.fold(
      (failure) => value = AuthState.error(failure.message),
      (_) => value = const AuthState.unauthenticated(),
    );
  }

  Future<void> _fetchAndSetUser() async {
    final result = await repository.getUserProfile();
    result.fold(
      (failure) => value = AuthState.error(failure.message),
      (user) => value = AuthState.authenticated(user),
    );
  }
}
