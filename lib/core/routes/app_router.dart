
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/main_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          const currentRole = UserRole.admin; // TODO Take Role from Auth State
          return const MainScreen(role: currentRole);
        },
      )
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not foundL ${state.uri.toString()}'),
      ),
    )
  );
}