import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';

import '../../features/testing/export.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final secureStorage = const FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Shared Preferences & Secure Storage
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Network Clients
  sl.registerLazySingleton<ApiClient>(() => ApiClient(secureStorage: sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
      apiClient: sl(),
    ),
  );

  // Data Sources
  if (dotenv.env['USE_MOCK_DATA'] == 'true') {
    sl.registerLazySingleton<AuthRemote>(() => AuthDummyRemote());
    sl.registerLazySingleton<UserRemote>(() => UserDummyRemote());
  } else {
    sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(apiClient: sl()));
    sl.registerLazySingleton<UserRemote>(() => UserRemoteImpl(apiClient: sl()));
  }

  // Providers
  sl.registerLazySingleton<ThemeProvider>(
    () {
      final themeStr = sl<SharedPreferences>().getString(SharedPrefs.themeMode);
      ThemeMode mode = ThemeMode.system;
      if (themeStr == ThemeMode.light.name) mode = ThemeMode.light;
      if (themeStr == ThemeMode.dark.name) mode = ThemeMode.dark;
      
      return ThemeProvider(themeMode: mode);
    },
  );

  sl.registerLazySingleton<AuthProvider>(
    () => AuthProvider(repository: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<UserProvider>(() => UserProvider(repository: sl()));
}
