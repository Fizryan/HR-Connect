import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/features/approval/approval_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/attendance/attendance_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/dashboard/dashboard_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/request/request_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/user_management/user_management_screen.dart';

class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final navIndexProvider = NotifierProvider<NavIndexNotifier, int>(
  NavIndexNotifier.new,
);

class _NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

class MainScreen extends ConsumerWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  List<_NavigationItem> _getNavigationItems(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    UserRole role,
  ) {
    final List<_NavigationItem> items = [
      _NavigationItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        page: DashboardScreen(user: user),
      ),
      _NavigationItem(
        label: 'Attendance',
        icon: Icons.calendar_today_outlined,
        selectedIcon: Icons.calendar_today,
        page: const AttendanceScreen(),
      ),
      _NavigationItem(
        label: 'Request',
        icon: Icons.file_open_outlined,
        selectedIcon: Icons.file_open,
        page: const RequestScreen(),
      ),
    ];

    if (role == UserRole.admin || role == UserRole.manager) {
      items.add(
        _NavigationItem(
          label: 'Management',
          icon: Icons.people_outlined,
          selectedIcon: Icons.people,
          page: const UserManagementScreen(),
        ),
      );
    }

    if (role != UserRole.staff) {
      items.add(
        _NavigationItem(
          label: 'Approval',
          icon: Icons.approval_outlined,
          selectedIcon: Icons.approval,
          page: const ApprovalScreen(),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final role = user.role;
    final navigationItems = _getNavigationItems(
      context,
      ref,
      colorScheme,
      role,
    );
    final selectedIndex = ref.watch(navIndexProvider);
    final safeIndex = selectedIndex >= navigationItems.length
        ? 0
        : selectedIndex;

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: safeIndex,
          children: navigationItems.map((item) => item.page).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: colorScheme.surfaceContainer,
        height: 66.h,
        elevation: 0,
        animationDuration: const Duration(milliseconds: 200),
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          ref.read(navIndexProvider.notifier).setIndex(index);
        },
        destinations: navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon, color: colorScheme.onSurface),
            selectedIcon: Icon(item.selectedIcon, color: colorScheme.onSurface),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
