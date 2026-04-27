import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/features/widgets/presentation/main_screen.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_state.dart';
import 'package:hr_connect/features/widgets/presentation/etc/auth/login_screen.dart';
import 'package:hr_connect/features/widgets/presentation/splash_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final authState = authProvider.value;
        final isAtSplash = state.uri.path == '/splash';
        final isGoingToLogin = state.uri.path == '/login';

        return authState.maybeWhen(
          initial: () => isAtSplash ? null : '/splash',
          loading: () => null,

          authenticated: (user) {
            if (isGoingToLogin || isAtSplash) return '/';
            return null;
          },
          unauthenticated: () {
            if (!isGoingToLogin) return '/login';
            return null;
          },
          error: (message) {
            if (!isGoingToLogin) return '/login';
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
            final authState = authProvider.value;
            final user = authState.maybeWhen(
              authenticated: (user) => user,
              orElse: () => null,
            );

            if (user == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong. Please try again.'),
                ),
              );
            }

            return MainScreen(user: user);
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
  }
}
