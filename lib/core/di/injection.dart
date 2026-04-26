import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/features/datasource_export.dart';
import 'package:hr_connect/features/providers_export.dart';
import 'package:hr_connect/features/repositories_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';

import '../../features/testing/export.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
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
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<OvertimeRepository>(
    () => OvertimeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  if (dotenv.env['USE_MOCK_DATA'] == 'true') {
    sl.registerLazySingleton<AuthRemote>(AuthDummyRemote.new);
    sl.registerLazySingleton<UserRemote>(UserDummyRemote.new);
  } else {
    sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(apiClient: sl()));
    sl.registerLazySingleton<UserRemote>(() => UserRemoteImpl(apiClient: sl()));
    sl.registerLazySingleton<AttendanceRemote>(
      () => AttendanceRemoteImpl(apiClient: sl()),
    );
    sl.registerLazySingleton<LeaveRemote>(
      () => LeaveRemoteImpl(apiClient: sl()),
    );
    sl.registerLazySingleton<OvertimeRemote>(
      () => OvertimeRemoteImpl(apiClient: sl()),
    );
  }

  // Providers
  sl.registerLazySingleton<ThemeProvider>(() {
    final themeStr = sl<SharedPreferences>().getString(SharedPrefs.themeMode);
    ThemeMode mode = ThemeMode.system;
    if (themeStr == ThemeMode.light.name) mode = ThemeMode.light;
    if (themeStr == ThemeMode.dark.name) mode = ThemeMode.dark;

    return ThemeProvider(themeMode: mode);
  });

  sl.registerLazySingleton<AuthProvider>(
    () => AuthProvider(repository: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<UserProvider>(() => UserProvider(repository: sl()));
  sl.registerLazySingleton<AttendanceProvider>(
    () => AttendanceProvider(repository: sl()),
  );
  sl.registerLazySingleton<LeaveProvider>(
    () => LeaveProvider(repository: sl()),
  );
  sl.registerLazySingleton<OvertimeProvider>(
    () => OvertimeProvider(repository: sl()),
  );
}
