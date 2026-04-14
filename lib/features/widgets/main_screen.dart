import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/admin/admin_control.dart';
import 'package:hr_connect/features/widgets/role_widgets.dart';
import 'package:hr_connect/features/widgets/shared/dialog_widget.dart';
import 'package:hr_connect/features/widgets/shared/profile_menu_tile_widgets.dart';
import 'package:provider/provider.dart';

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
        page: Scaffold(),
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
        backgroundColor: colorScheme.onSecondary.withValues(alpha: 0.4),
        height: 74.h,
        elevation: 0,
        animationDuration: const Duration(seconds: 2),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.4),
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon, color: colorScheme.onSurface),
            selectedIcon: Icon(item.selectedIcon, color: colorScheme.primary),
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
                "No image",
                style: TextStyle(
                  color: colorScheme.onSurface,
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
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.verified, color: colorScheme.primary, size: 18.sp),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(),
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
              icon: colorScheme.brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              title: 'Toggle Theme',
              onTap: () => context.read<ThemeProvider>().toggleTheme(),
            ),
            Divider(),
            ProfileMenuTile(
              icon: Icons.logout_outlined,
              title: 'Logout',
              iconColor: colorScheme.error,
              textColor: colorScheme.error,
              backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.3),
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
        return Scaffold();
      case UserRole.manager:
        return Scaffold();
      case UserRole.supervisor:
        return Scaffold();
      case UserRole.staff:
        return Scaffold();
    }
  }
}
