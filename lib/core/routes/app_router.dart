import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/auth/providers/auth_state.dart';
import 'package:hr_connect/features/widgets/presentation/etc/login_screen.dart';
import 'package:hr_connect/features/widgets/splash_screen.dart';

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
      final isGoingToLogin = state.uri.path == '/login';

      return authState.maybeWhen(
        initial: () => isAtSplash ? null : '/splash',
        loading: () => null,

        authenticated: (user) {
          if (isGoingToLogin || isAtSplash) return '/';
          return null;
        },

        unauthenticated: (message) {
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
          final authState = authStateNotifier.value;

          final user = authState.maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );

          if (user == null) {
            return const Scaffold(
              body: Center(
                child: Text('An error occurred while loading user data.'),
              ),
            );
          }

          return const Scaffold(); // TODO: Main Screen
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
