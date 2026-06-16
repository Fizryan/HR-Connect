import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/constants/secure_storage.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

final accessTokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return storage.read(key: SecureStorage.accessToken);
});

final avatarNotifierProvider = AsyncNotifierProvider<AvatarNotifier, String?>(
  AvatarNotifier.new,
);

class AvatarNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  Future<void> uploadAndUpdateProfile(File file) async {
    state = const AsyncValue.loading();

    final repository = ref.read(avatarRepositoryProvider);
    final result = await repository.uploadAvatar(file);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (url) async {
        try {
          final currentUser = ref.read(authNotifierProvider).value;
          if (currentUser != null) {
            final updatedData = currentUser.data.copyWith(avatarUrl: url);
            await ref
                .read(userNotifierProvider.notifier)
                .updateUser(currentUser.id, updatedData);
          }
          state = AsyncValue.data(url);
        } catch (e) {
          state = AsyncValue.error(
            'Failed to update profile.',
            StackTrace.current,
          );
        }
      },
    );
  }

  Future<String> getAvatarUrl(String filename) async {
    final repository = ref.read(avatarRepositoryProvider);
    final result = await repository.getAvatarUrl(filename);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (url) => url,
    );
  }
}
