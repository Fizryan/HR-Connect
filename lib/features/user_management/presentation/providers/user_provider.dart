import 'package:flutter/material.dart';
import 'package:hr_connect/features/user_management/domain/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_state.dart';

class UserProvider extends ValueNotifier<UserState> {
  final UserRepository repository;

  UserProvider({required this.repository}) : super(const UserState.initial());

  Future<void> fetchUserProfile() async {
    value = const UserState.loading();
    
    final result = await repository.getUserData();
    
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (user) => value = UserState.data(user),
    );
  }
}
