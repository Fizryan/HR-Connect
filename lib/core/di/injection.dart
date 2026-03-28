import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/const/shared_preferences.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerFactory<ThemeProvider>(
    () => ThemeProvider(
      isDarkMode: sl<SharedPreferences>().getBool(SharedPrefs.isDarkMode) ?? false,
    ),
  );
}