import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';

class _NavDest {
  final int branchIndex;
  final NavigationDestination destination;

  _NavDest({required this.branchIndex, required this.destination});
}

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<_NavDest> navDestinations = [
      _NavDest(
        branchIndex: 0,
        destination: NavigationDestination(
          icon: Icon(Icons.dashboard_outlined, color: colorScheme.onSurface),
          selectedIcon: Icon(Icons.dashboard, color: colorScheme.onSurface),
          label: 'Dashboard',
        ),
      ),
      _NavDest(
        branchIndex: 1,
        destination: NavigationDestination(
          icon: Icon(Icons.file_open_outlined, color: colorScheme.onSurface),
          selectedIcon: Icon(Icons.file_open, color: colorScheme.onSurface),
          label: 'Request',
        ),
      ),
      if (currentUser.data.role == Role.admin ||
          currentUser.data.role == Role.manager) ...[
        _NavDest(
          branchIndex: 2,
          destination: NavigationDestination(
            icon: Icon(Icons.people_outline, color: colorScheme.onSurface),
            selectedIcon: Icon(Icons.people, color: colorScheme.onSurface),
            label: 'Management',
          ),
        ),
      ],
    ];

    int uiIndex = navDestinations.indexWhere(
      (dest) => dest.branchIndex == navigationShell.currentIndex,
    );

    if (uiIndex == -1) uiIndex = 0;

    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        backgroundColor: colorScheme.surfaceContainer,
        height: 66.h,
        elevation: 0,
        animationDuration: const Duration(milliseconds: 200),
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: uiIndex,
        onDestinationSelected: (int tappedUiIndex) {
          final targetBranch = navDestinations[tappedUiIndex].branchIndex;
          navigationShell.goBranch(
            targetBranch,
            initialLocation: targetBranch == navigationShell.currentIndex,
          );
        },
        destinations: navDestinations.map((e) => e.destination).toList(),
      ),
    );
  }
}
