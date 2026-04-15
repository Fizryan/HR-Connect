import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/core/routes/app_router.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(sl<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<ThemeProvider>()),
        ChangeNotifierProvider.value(value: sl<UserProvider>()),
        ChangeNotifierProvider.value(value: sl<AuthProvider>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 830),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return MaterialApp.router(
                title: 'HR Connect',
                debugShowCheckedModeBanner: false,
                themeMode: themeProvider.themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerConfig: _router,
              );
            }
          );
        },
      ),
    );
  }
}
