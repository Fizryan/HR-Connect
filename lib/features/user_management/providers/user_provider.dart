import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
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
    state = const AsyncValue.loading();

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUserById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data([user]),
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> updateData) async {
    final previousState = state;

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.updateUser(id, updateData);

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
      (updatedUser) {
        if (previousState.hasValue) {
          final updatedList = previousState.value!.map((user) {
            return user.id == id ? updatedUser : user;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> activateUser(String id) async {
    final previousState = state;

    if (previousState.hasValue) {
      final optimisticList = previousState.value!.map((user) {
        return user.id == id ? user.copyWith(isActive: true) : user;
      }).toList();
      state = AsyncValue.data(optimisticList);
    }

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.activateUser(id);

    result.fold((failure) {
      state = AsyncValue<List<UserModel>>.error(
        failure.message,
        StackTrace.current,
      );
      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }

  Future<void> deactivateUser(String id) async {
    final previousState = state;

    if (previousState.hasValue) {
      final optimisticList = previousState.value!.map((user) {
        return user.id == id ? user.copyWith(isActive: false) : user;
      }).toList();
      state = AsyncValue.data(optimisticList);
    }

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.deactivateUser(id);

    result.fold((failure) {
      state = AsyncValue<List<UserModel>>.error(
        failure.message,
        StackTrace.current,
      );
      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }

  Future<void> deleteUser(String id) async {
    final previousState = state;

    if (previousState.hasValue) {
      final optimisticList = previousState.value!
          .where((user) => user.id != id)
          .toList();
      state = AsyncValue.data(optimisticList);
    }

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.deleteUser(id);

    result.fold((failure) {
      state = AsyncValue<List<UserModel>>.error(
        failure.message,
        StackTrace.current,
      );
      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }
}
