import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/features/login/login_screen.dart';
import 'package:hr_connect/features/widgets/presentation/main_screen.dart';
import 'package:hr_connect/features/widgets/presentation/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = ValueNotifier<AsyncValue<UserModel?>>(
    ref.read(authNotifierProvider),
  );

  final splashDelayNotifier = ValueNotifier<bool>(false);

  ref.onDispose(() {
    authStateNotifier.dispose();
    splashDelayNotifier.dispose();
  });

  Future.delayed(const Duration(seconds: 1), () {
    splashDelayNotifier.value = true;
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
    debugLogDiagnostics: false,
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
        path: '/',
        name: 'home',
        builder: (context, state) {
          final authState = authStateNotifier.value;
          final user = authState.value;

          if (user == null) {
            return const Scaffold(
              body: Center(
                child: Text('An error occurred while loading user data.'),
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
});
