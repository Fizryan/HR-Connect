import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_state.dart';

class AuthProvider extends ValueNotifier<AuthState> {
  final AuthRepository repository;

  AuthProvider({required this.repository}) : super(const AuthState.initial());

  Future<void> fetchUserProfile() async {
    value = const AuthState.loading();
    
    final result = await repository.getUserData();
    
    result.fold(
      (failure) => value = AuthState.error(failure.message),
      (user) => value = AuthState.data(user),
    );
  }
}
