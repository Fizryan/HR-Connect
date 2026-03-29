import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/network/api_client.dart';

import 'package:hr_connect/features/user_management/data/datasources/user_remote.dart';
import 'package:hr_connect/features/user_management/domain/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';

import 'package:hr_connect/core/theme/theme_provider.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<UserRemote>(() => UserRemoteImpl(apiClient: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(remoteDataSource: sl()));

  sl.registerFactory<ThemeProvider>(
    () => ThemeProvider(
      isDarkMode: sl<SharedPreferences>().getBool(SharedPrefs.isDarkMode) ?? false,
    ),
  );

  sl.registerFactory<UserProvider>(
    () => UserProvider(repository: sl())
  );
}
