import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/core/main_screen.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_state.dart';
import 'package:hr_connect/features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static final _authProvider = sl<AuthProvider>();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _authProvider,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = _authProvider.value;
      final isGoingToLogin = state.uri.path == '/login';

      return authState.maybeWhen(
        initial: () => null,
        loading: () => null,
        
        authenticated: (user) {
          if (isGoingToLogin) return '/';
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
        path: '/',
        name: 'home',
        builder: (context, state) {
          final authState = _authProvider.value;
          final user = authState.maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );
          
          if (user == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
