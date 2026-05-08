import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/user_management/providers/user_state.dart';

final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState.initial();
  }

  Future<void> fetchUsers({int page = 1, int limit = 20}) async {
    state = const UserState.loading();

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUsers(page: page, limit: limit);

    state = result.fold(
      (failure) => UserState.error(failure.message),
      UserState.loaded,
    );
  }

  Future<void> fetchUserById(String id) async {
    state = const UserState.loading();

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUserById(id);

    state = result.fold(
      (failure) => UserState.error(failure.message),
      (user) => UserState.loaded([user]),
    );
  }

  Future<void> updateUser(String id, Map<String, dynamic> updateData) async {
    final previousState = state;

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.updateUser(id, updateData);

    result.fold(
      (failure) {
        state = UserState.error(failure.message);
        Future.delayed(const Duration(seconds: 2), () {
          state = previousState;
        });
      },
      (updatedUser) {
        previousState.maybeMap(
          loaded: (currentState) {
            final updatedList = currentState.users.map((user) {
              return user.id == id ? updatedUser : user;
            }).toList();

            state = UserState.loaded(updatedList);
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> deactivateUser(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    final previousState = state;

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.deactivateUser(id, updateData);

    result.fold(
      (failure) {
        state = UserState.error(failure.message);
        Future.delayed(const Duration(seconds: 2), () {
          state = previousState;
        });
      },
      (updatedUser) {
        previousState.maybeMap(
          loaded: (currentState) {
            final updatedList = currentState.users.map((user) {
              return user.id == id ? updatedUser : user;
            }).toList();

            state = UserState.loaded(updatedList);
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> deleteUser(String id) async {
    final previousState = state;

    previousState.maybeMap(
      loaded: (currentState) {
        final optimisticList = currentState.users
            .where((user) => user.id != id)
            .toList();

        state = UserState.loaded(optimisticList);
      },
      orElse: () {},
    );

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.deleteUser(id);

    result.fold((failure) {
      state = UserState.error(failure.message);

      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }
}
