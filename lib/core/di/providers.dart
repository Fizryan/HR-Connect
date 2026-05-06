import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:hr_connect/features/user_management/data/datasource/user_remote.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Override in main.dart
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

final authRemoteProvider = Provider<AuthRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteImpl(apiClient: apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImp(
    remoteDataSource: ref.watch(authRemoteProvider),
    secureStorage: ref.watch(secureStorageProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

final userRemoteProvider = Provider<UserRemote>((ref) {
  return UserRemoteImp(apiClient: ref.watch(apiClientProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImp(remoteDataSource: ref.watch(userRemoteProvider));
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeStr = prefs.getString(SharedPrefs.themeMode);

    if (themeStr == ThemeMode.light.name) return ThemeMode.light;
    if (themeStr == ThemeMode.dark.name) return ThemeMode.dark;
    return ThemeMode.system;
  }

  void updateTheme(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(SharedPrefs.themeMode, mode.name);
  }

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;

    state = mode;

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(SharedPrefs.themeMode, mode.name);
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});