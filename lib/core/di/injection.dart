import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/network/api_client.dart';

import 'package:hr_connect/features/auth/data/datasources/auth_remote.dart';
import 'package:hr_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';

import 'package:hr_connect/core/theme/theme_provider.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(apiClient: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  sl.registerFactory<ThemeProvider>(
    () => ThemeProvider(
      isDarkMode: sl<SharedPreferences>().getBool(SharedPrefs.isDarkMode) ?? false,
    ),
  );

  sl.registerFactory<AuthProvider>(
    () => AuthProvider(repository: sl())
  );
}
