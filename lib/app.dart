import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/core/routes/app_router.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:hr_connect/features/export/providers_export.dart';
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
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<ThemeProvider>()),
        ChangeNotifierProvider.value(value: sl<AccountProvider>()),
        ChangeNotifierProvider.value(value: sl<UserProvider>()),
        ChangeNotifierProvider.value(value: sl<AuthProvider>()),
        ChangeNotifierProvider.value(value: sl<AttendanceProvider>()),
        ChangeNotifierProvider.value(value: sl<LeaveProvider>()),
        ChangeNotifierProvider.value(value: sl<OvertimeProvider>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 830),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeMode = context.select((ThemeProvider p) => p.themeMode);
          return MaterialApp.router(
            title: 'HR Connect',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
