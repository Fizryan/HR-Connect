import 'package:flutter/material.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/user_management/domain/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_state.dart';

class UserProvider extends ValueNotifier<UserState> {
  final UserRepository repository;

  UserProvider({required this.repository}) : super(const UserState.initial());

  Future<void> fetchAllUsers() async {
    value = const UserState.loading();
    final result = await repository.getAllUsers();
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (users) => value = UserState.dataList(users),
    );
  }

  Future<void> getUserByUid(String id) async {
    value = const UserState.loading();
    final result = await repository.getUserByUid(id);
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (user) => value = UserState.data(user),
    );
  }

  Future<void> createUser(UserModel user) async {
    value = const UserState.loading();
    final result = await repository.createUser(user);
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (user) => value = const UserState.success('User created successfully'),
    );
  }

  Future<void> updateUser(UserModel user) async {
    value = const UserState.loading();
    final result = await repository.updateUser(user);
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (user) => value = const UserState.success('User updated successfully'),
    );
  }

  Future<void> deleteUser(String id) async {
    value = const UserState.loading();
    final result = await repository.deleteUser(id);
    result.fold(
      (failure) => value = UserState.error(failure.message),
      (_) => value = const UserState.success('User deleted successfully'),
    );
  }
}
