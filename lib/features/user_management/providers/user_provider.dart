import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<UserModel>>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<List<UserModel>> {
  int _currentPage = 1;
  bool _hasMore = true;
  DateTime? lastFetchTime;

  @override
  FutureOr<List<UserModel>> build() async {
    _currentPage = 1;
    _hasMore = true;
    final data = await _fetchUsersLogic(page: _currentPage, limit: 20);
    lastFetchTime = DateTime.now();

    return data;
  }

  Future<List<UserModel>> _fetchUsersLogic({
    int page = 1,
    int limit = 20,
  }) async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUsers(page: page, limit: limit);

    return result.fold((failure) => throw failure.message, (users) {
      if (users.length < limit) _hasMore = false;
      return users;
    });
  }

  Future<void> fetchUsers({int page = 1, int limit = 20}) async {
    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 15;

    if (state.isLoading) return;

    if (isCacheValid && state.hasValue && state.value!.isNotEmpty) {
      return;
    }

    await refreshUsers(page: page, limit: limit);
  }

  Future<void> refreshUsers({int page = 1, int limit = 20}) async {
    state = const AsyncValue.loading();
    _currentPage = page;
    _hasMore = true;

    state = await AsyncValue.guard(
      () => _fetchUsersLogic(page: page, limit: limit),
    );

    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<void> loadMore({int limit = 20}) async {
    if (!_hasMore || state.isLoading) return;

    final currentUsers = state.value ?? [];
    state = const AsyncValue.loading();

    try {
      _currentPage++;
      final newUsers = await _fetchUsersLogic(page: _currentPage, limit: limit);
      state = AsyncValue.data([...currentUsers, ...newUsers]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchUserById(String id) async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUserById(id);

    result.fold(
      (failure) {
        debugPrint('Failed to fetch user: ${failure.message}');
      },
      (fetchedUser) {
        if (state.hasValue) {
          final updatedList = state.value!.map((user) {
            return user.id == id ? fetchedUser : user;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> _handleMutation<T>({
    required Future<Either<Failure, T>> Function() action,
    List<UserModel> Function(List<UserModel> currentList)? optimisticUpdate,
    void Function(T successData)? onSuccess,
  }) async {
    final previousState = state;

    if (optimisticUpdate != null && previousState.hasValue) {
      state = AsyncValue.data(optimisticUpdate(previousState.value!));
    }

    final result = await action();

    result.fold(
      (failure) {
        state = AsyncValue<List<UserModel>>.error(
          failure.message,
          StackTrace.current,
        );
        Future.delayed(const Duration(seconds: 2), () {
          state = previousState;
        });
      },
      (successData) {
        if (onSuccess != null) {
          onSuccess(successData);
        }
      },
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> updateData) async {
    await _handleMutation(
      action: () => ref.read(userRepositoryProvider).updateUser(id, updateData),
      onSuccess: (updatedUser) {
        if (state.hasValue) {
          final updatedList = state.value!.map((user) {
            return user.id == id ? updatedUser : user;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> activateUser(String id) async {
    await _handleMutation(
      action: () => ref.read(userRepositoryProvider).activateUser(id),
      optimisticUpdate: (current) => current.map((user) {
        return user.id == id ? user.copyWith(isActive: true) : user;
      }).toList(),
    );
  }

  Future<void> deactivateUser(String id) async {
    await _handleMutation(
      action: () => ref.read(userRepositoryProvider).deactivateUser(id),
      optimisticUpdate: (current) => current.map((user) {
        return user.id == id ? user.copyWith(isActive: false) : user;
      }).toList(),
    );
  }

  Future<void> deleteUser(String id) async {
    await _handleMutation(
      action: () => ref.read(userRepositoryProvider).deleteUser(id),
      optimisticUpdate: (current) =>
          current.where((user) => user.id != id).toList(),
    );
  }
}
