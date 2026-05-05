import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/auth/providers/auth_state.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/etc/login_screen.dart';
import 'package:hr_connect/features/widgets/presentation/main_screen.dart';
import 'package:hr_connect/features/widgets/presentation/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = ValueNotifier<AuthState>(
    ref.read(authNotifierProvider),
  );

  ref.onDispose(authStateNotifier.dispose);

  ref.listen<AuthState>(authNotifierProvider, (_, next) {
    authStateNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authStateNotifier,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = authStateNotifier.value;
      final isAtSplash = state.uri.path == '/splash';
      final isGoingToLogin = state.uri.path == '/';

      return authState.maybeWhen(
        initial: () => isAtSplash ? null : '/splash',
        loading: () => null,

        authenticated: (user) {
          if (isGoingToLogin || isAtSplash) return '/';
          return null;
        },

        unauthenticated: (message) {
          if (!isGoingToLogin) return '/';
          return null;
        },

        orElse: () => null,
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          // final authState = authStateNotifier.value;

          // final user = authState.maybeWhen(
          //   authenticated: (user) => user,
          //   orElse: () => null,
          // );

          const user = UserModel(
            email: 'fizryan@mail.com',
            password: 'password123',
            firstName: 'Hafizryandin',
            lastName: 'Haykal Matondang',
            role: UserRole.admin,
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          );

          // if (user == null) {
          //   return const Scaffold(
          //     body: Center(
          //       child: Text('An error occurred while loading user data.'),
          //     ),
          //   );
          // }

          return const MainScreen(user: user);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );
});
