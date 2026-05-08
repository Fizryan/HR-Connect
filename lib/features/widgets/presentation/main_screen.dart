import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/dashboard/admin/user_management_screen.dart';
import 'package:hr_connect/features/widgets/presentation/etc/about_screen.dart';
import 'package:hr_connect/features/widgets/presentation/etc/edit_profile_screen.dart';
import 'package:hr_connect/features/widgets/presentation/etc/support_screen.dart';
import 'package:hr_connect/features/widgets/presentation/etc/theme_screen.dart';
import 'package:hr_connect/features/widgets/shared/profile_menu_tile.dart';

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

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

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
        page: _buildDashboardContent(colorScheme, role),
      ),
      _NavigationItem(
        label: 'Request',
        icon: Icons.file_open_outlined,
        selectedIcon: Icons.file_open,
        page: const Scaffold(),
      ),
    ];

    if (role == UserRole.admin) {
      items.add(
        _NavigationItem(
          label: 'Management',
          icon: Icons.people_outlined,
          selectedIcon: Icons.people,
          page: const UserManagementScreen(),
        ),
      );
    }

    items.add(
      _NavigationItem(
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        page: _buildProfileContent(context, ref, colorScheme, role, user),
      ),
    );

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

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    UserRole role,
    UserModel user,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: user.avatarUrl ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40.r,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 40.r,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child: Text(
                      'N/A',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 40.r,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person, color: colorScheme.primary),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.firstName,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.lastName,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: colorScheme.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'HRConnect | ${_capitalize(role.name)}',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: colorScheme.surfaceContainerLowest,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 15.r,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileMenuTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 56.w,
                    endIndent: 20.w,
                    color: colorScheme.outlineVariant,
                  ),
                  ProfileMenuTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 56.w,
                    endIndent: 20.w,
                    color: colorScheme.outlineVariant,
                  ),
                  ProfileMenuTile(
                    icon: Icons.style_outlined,
                    title: 'Theme Mode',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThemeScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 56.w,
                    endIndent: 20.w,
                    color: colorScheme.outlineVariant,
                  ),
                  ProfileMenuTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupportScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.5),
                  width: 1.w,
                ),
              ),
              child: ProfileMenuTile(
                icon: Icons.logout_outlined,
                title: 'Logout',
                iconColor: colorScheme.onErrorContainer,
                textColor: colorScheme.onErrorContainer,
                onTap: () => _showLogoutDialog(context, ref, colorScheme),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(context);
                ref.read(authNotifierProvider.notifier).logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboardContent(ColorScheme colorScheme, UserRole role) {
    switch (role) {
      case UserRole.admin:
      case UserRole.director:
      case UserRole.manager:
      case UserRole.supervisor:
      case UserRole.staff:
      default:
        return const Scaffold(
          body: Center(
            child: Text('An error occurred while loading user data.'),
          ),
        );
    }
  }
}
