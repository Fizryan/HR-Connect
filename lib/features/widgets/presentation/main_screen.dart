import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/role/admin/admin_control.dart';
import 'package:hr_connect/features/export/role_widgets.dart';
import 'package:hr_connect/features/widgets/presentation/shared/dialog_widget.dart';
import 'package:hr_connect/features/widgets/presentation/shared/profile_menu_tile_widgets.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

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

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  List<_NavigationItem> _getNavigationItems(
    ColorScheme colorScheme,
    UserRole role,
  ) {
    final List<_NavigationItem> items = [
      _NavigationItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        page: _buildDashboardPage(colorScheme, role),
      ),
      _NavigationItem(
        label: 'Requests',
        icon: Icons.file_open_outlined,
        selectedIcon: Icons.file_open_rounded,
        page: const Scaffold(),
      ),
    ];

    if (role == UserRole.admin) {
      items.add(
        _NavigationItem(
          label: 'Admin',
          icon: Icons.admin_panel_settings_outlined,
          selectedIcon: Icons.admin_panel_settings_rounded,
          page: AdminControl(colorScheme: colorScheme),
        ),
      );
    }

    items.add(
      _NavigationItem(
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        page: _buildProfileContent(colorScheme, role),
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final role = widget.user.role;
    final navigationItems = _getNavigationItems(colorScheme, role);
    final safeIndex = _selectedIndex >= navigationItems.length
        ? 0
        : _selectedIndex;

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: safeIndex,
          children: navigationItems.map((item) => item.page).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: colorScheme.surfaceContainerLowest,
        height: 74.h,
        elevation: 0,
        animationDuration: const Duration(seconds: 2),
        indicatorColor: colorScheme.onSurface.withValues(alpha: 0.8),
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(
              item.icon,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedIcon: Icon(item.selectedIcon, color: colorScheme.surface),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDashboardPage(ColorScheme colorScheme, UserRole role) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildDashboardContent(colorScheme, role),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(ColorScheme colorScheme, UserRole role) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.user.avatarUrl ?? '',
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(radius: 60.r, backgroundImage: imageProvider),
              placeholder: (context, url) => Text(
                'No image',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            SizedBox(height: 16.h),
            Text(
              '${widget.user.firstName} ${widget.user.lastName}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HRConnect | ${_capitalize(role.name)}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.verified, color: colorScheme.primary, size: 18.sp),
              ],
            ),
            SizedBox(height: 16.h),
            const Divider(),
            ProfileMenuTile(
              icon: Icons.support_agent_outlined,
              title: 'Support',
              onTap: () => DialogWidget.showSupportDialog(context, colorScheme),
            ),
            ProfileMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'About',
              onTap: () => DialogWidget.showAboutDialog(context, colorScheme),
            ),
            ProfileMenuTile(
              icon: Icons.color_lens_outlined,
              title: 'Theme Settings',
              onTap: () => DialogWidget.showThemeDialog(context, colorScheme),
            ),
            const Divider(),
            ProfileMenuTile(
              icon: Icons.logout_outlined,
              title: 'Logout',
              iconColor: colorScheme.onError,
              textColor: colorScheme.onError,
              backgroundColor: colorScheme.error.withValues(alpha: 0.8),
              onTap: () => DialogWidget.showLogoutDialog(context, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ColorScheme colorScheme, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AdminDashboard(colorScheme: colorScheme);
      case UserRole.director:
        return const Scaffold();
      case UserRole.manager:
        return const Scaffold();
      case UserRole.supervisor:
        return const Scaffold();
      case UserRole.staff:
        return const Scaffold();
    }
  }
}
