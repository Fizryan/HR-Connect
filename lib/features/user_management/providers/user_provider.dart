import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart'; // Pastikan path ini mengarah ke file di mana userRepositoryProvider berada
import 'package:hr_connect/features/user_management/providers/user_state.dart';

final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);

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

  Future<void> fetchUserById(String emailIdentifier) async {
    state = const UserState.loading();
    
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getUserById(emailIdentifier);

    state = result.fold(
      (failure) => UserState.error(failure.message),
      (user) => UserState.loaded([user]),
    );
  }

  Future<void> updateUser(
    String emailIdentifier,
    Map<String, dynamic> updateData,
  ) async {
    final previousState = state;

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.updateUser(emailIdentifier, updateData);

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
              return user.email == emailIdentifier ? updatedUser : user;
            }).toList();

            state = UserState.loaded(updatedList);
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> deactivateUser(String emailIdentifier) async {
    final previousState = state;

    previousState.maybeMap(
      loaded: (currentState) {
        final optimisticList = currentState.users
            .where((user) => user.email != emailIdentifier)
            .toList();

        state = UserState.loaded(optimisticList);
      },
      orElse: () {},
    );

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.deactivateUser(emailIdentifier);

    result.fold((failure) {
      state = UserState.error(failure.message);
      
      Future.delayed(const Duration(seconds: 2), () {
        state = previousState;
      });
    }, (_) {});
  }
}