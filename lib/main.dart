import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:hr_connect/features/auth/views/login_view.dart';
import 'package:hr_connect/features/dashboard/controllers/dashboard_controller.dart';
import 'package:hr_connect/features/firebase/firebase_options.dart';
import 'package:hr_connect/features/navigation/views/menu_view.dart';
import 'package:hr_connect/features/settings/controllers/settings_controller.dart';
import 'package:hr_connect/features/user_management/controllers/user_management_controller.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:hr_connect/features/reports/controllers/reports_controller.dart';
import 'package:hr_connect/features/reimbursement/controllers/reimbursement_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_connect/core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDarkMode: isDarkMode),
        ),
        ChangeNotifierProvider(create: (context) => UserManagementController()),
        ChangeNotifierProvider(create: (context) => SettingsController()),
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (context) => AttendanceController()),
        ChangeNotifierProvider(create: (context) => LeaveController()),
        ChangeNotifierProvider(create: (context) => ReportsController()),
        ChangeNotifierProvider(create: (context) => ReimbursementController()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return Consumer<AuthController>(
              builder: (context, auth, _) {
                return MaterialApp(
                  navigatorKey: _navigatorKey,
                  title: 'HR-Connect',
                  debugShowCheckedModeBanner: false,
                  themeMode: themeProvider.isDarkMode
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.background,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: AppColors.primary,
                      brightness: Brightness.light,
                      surface: AppColors.surface,
                      onSurface: AppColors.textPrimary,
                    ),
                    useMaterial3: true,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                  darkTheme: ThemeData(
                    scaffoldBackgroundColor: AppColors.darkBackground,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: AppColors.primary,
                      brightness: Brightness.dark,
                      surface: AppColors.darkSurface,
                      onSurface: AppColors.darkTextPrimary,
                    ),
                    useMaterial3: true,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: AppColors.darkSurface,
                      foregroundColor: AppColors.darkTextPrimary,
                    ),
                  ),
                  home: _buildHome(auth),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHome(AuthController auth) {
    switch (auth.status) {
      case AuthStatus.authenticated:
        return MenuView(key: ValueKey(auth.user!.uid), user: auth.user!);
      case AuthStatus.unauthenticated:
        return const LoginView(key: ValueKey('login'));
      default:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
