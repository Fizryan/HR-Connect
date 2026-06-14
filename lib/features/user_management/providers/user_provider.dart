import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<UserModel>>(UserNotifier.new);

class UserNotifier extends BaseListNotifier<UserModel> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<UserModel>> build() async {
    final data = await _fetchUsersLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<UserModel>> _fetchUsersLogic() async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getAllUsers();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (users) => users,
    );
  }

  Future<void> fetchUsers() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 10;

    if (isCacheValid && state.hasValue) return;

    await refreshUsers();
  }

  Future<void> refreshUsers() async {
    state = await AsyncValue.guard(_fetchUsersLogic);

    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<Either<Failure, void>> registerUser(
    UserData data,
    String password,
  ) async {
    final repository = ref.read(userRepositoryProvider);
    return handleMutation(
      action: () => repository.registerUser(data, password),
      optimisticUpdate: (currentList) {
        final newUser = UserModel(
          id: 'temp_id_${DateTime.now().millisecondsSinceEpoch}',
          data: data,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return [newUser, ...currentList];
      },
      onSuccess: (_) {
        refreshUsers();
      },
    );
  }

  Future<Either<Failure, void>> updateUser(String id, UserData newData) async {
    final repository = ref.read(userRepositoryProvider);
    return handleMutation<void>(
      action: () => repository.updateUser(id, newData),
      optimisticUpdate: (currentList) {
        return currentList.map((user) {
          if (user.id == id) return user.copyWith(data: newData);
          return user;
        }).toList();
      },
      onSuccess: (_) {
        refreshUsers();
      },
    );
  }

  Future<Either<Failure, void>> deleteUser(String id) async {
    final repository = ref.read(userRepositoryProvider);
    return handleMutation<void>(
      action: () => repository.deleteUser(id),
      optimisticUpdate: (currentList) {
        return currentList.where((user) => user.id != id).toList();
      },
      onSuccess: (_) {
        refreshUsers();
      },
    );
  }

  Future<Either<Failure, void>> activateUser(String id) async {
    final repository = ref.read(userRepositoryProvider);
    return handleMutation<void>(
      action: () => repository.activateUser(id),
      optimisticUpdate: (currentList) {
        return currentList.map((user) {
          if (user.id == id) return user.copyWith(isActive: true);
          return user;
        }).toList();
      },
      onSuccess: (_) {
        refreshUsers();
      },
    );
  }

  Future<Either<Failure, void>> deactivateUser(String id) async {
    final repository = ref.read(userRepositoryProvider);
    return handleMutation<void>(
      action: () => repository.deactivateUser(id),
      optimisticUpdate: (currentList) {
        return currentList.map((user) {
          if (user.id == id) return user.copyWith(isActive: false);
          return user;
        }).toList();
      },
      onSuccess: (_) {
        refreshUsers();
      },
    );
  }
}
