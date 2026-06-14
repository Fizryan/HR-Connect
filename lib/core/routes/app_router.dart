import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/env_config.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hr_connect/features/shared/screen/about_screen.dart';
import 'package:hr_connect/features/shared/screen/add_request_screen.dart';
import 'package:hr_connect/features/shared/screen/change_password_screen.dart';
import 'package:hr_connect/features/shared/screen/edit_profile_screen.dart';
import 'package:hr_connect/features/shared/screen/request_detail_screen.dart';
import 'package:hr_connect/features/shared/screen/request_screen.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/auth/presentation/login_screen.dart';
import 'package:hr_connect/features/shared/main_screen.dart';
import 'package:hr_connect/features/shared/screen/support_screen.dart';
import 'package:hr_connect/features/shared/screen/theme_screen.dart';
import 'package:hr_connect/features/shared/splash_screen.dart';
import 'package:hr_connect/features/user_management/presentation/add_user_screen.dart';
import 'package:hr_connect/features/user_management/presentation/edit_user_screen.dart';
import 'package:hr_connect/features/user_management/presentation/user_management_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = ValueNotifier<AsyncValue<UserModel?>>(
    ref.read(authNotifierProvider),
  );

  final splashDelayNotifier = ValueNotifier<bool>(false);

  final splashTimer = Timer(const Duration(seconds: 1), () {
    splashDelayNotifier.value = true;
  });

  ref.onDispose(() {
    splashTimer.cancel();
    authStateNotifier.dispose();
    splashDelayNotifier.dispose();
  });

  ref.listen<AsyncValue<UserModel?>>(authNotifierProvider, (_, next) {
    authStateNotifier.value = next;
  });

  final refreshNotifier = Listenable.merge([
    authStateNotifier,
    splashDelayNotifier,
  ]);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    debugLogDiagnostics: EnvConfig.isDevelopment,
    redirect: (context, state) {
      final authState = authStateNotifier.value;
      final isAtSplash = state.uri.path == '/splash';
      final isGoingToLogin = state.uri.path == '/login';

      if (!isAtSplash && !splashDelayNotifier.value) return '/splash';
      if (!splashDelayNotifier.value) return null;

      if (authState.isLoading) return null;

      final isAuthenticated = authState.hasValue && authState.value != null;

      if (isAuthenticated) {
        if (isGoingToLogin || isAtSplash) return '/';

        final currentUser = authState.value!.data.role;
        final isAuthorize =
            currentUser == Role.admin || currentUser == Role.manager;

        final isManagementPath =
            state.uri.path.startsWith('/management') ||
            state.uri.path.startsWith('/add-user') ||
            state.uri.path.startsWith('/edit-user');

        if (isManagementPath && !isAuthorize) {
          return '/';
        }

        return null;
      } else {
        if (!isGoingToLogin) return '/login';
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/theme',
        name: 'theme',
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/edit-user',
        name: 'edit user',
        builder: (context, state) {
          final userToEdit = state.extra as UserModel;
          return EditUserScreen(user: userToEdit);
        },
      ),
      GoRoute(
        path: '/add-user',
        name: 'add user',
        builder: (context, state) => const AddUserScreen(),
      ),
      GoRoute(
        path: '/request-detail',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return RequestDetailScreen(
            requestId: args['id'] as String,
            requestKind: args['kind'] as RequestKind,
            type: args['type'] as String,
            description: args['description'] as String,
            startDate: args['startDate'] as DateTime,
            endDate: args['endDate'] as DateTime,
            status: args['status'] as RequestStatus,
          );
        },
      ),
      GoRoute(
        path: '/add-request',
        name: 'add request',
        builder: (context, state) => const AddRequestScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/request',
                name: 'request',
                builder: (context, state) => const RequestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/management',
                name: 'management',
                builder: (context, state) =>
                    const Scaffold(body: UserManagementScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Page not found: ${state.uri.toString()}'),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    ),
  );
});
