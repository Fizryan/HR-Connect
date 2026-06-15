import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return Container(
        height: 76.h,
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: currentUser.data.avatarUrl ?? '',
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(radius: 22.r, backgroundImage: imageProvider),
            placeholder: (context, url) =>
                _buildFallbackAvatar(colorScheme, currentUser),
            errorWidget: (context, url, error) =>
                _buildFallbackAvatar(colorScheme, currentUser),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentUser.data.firstName} ${currentUser.data.lastName.isNotEmpty ? '${currentUser.data.lastName[0].toUpperCase()}.' : ''}'
                      .trim(),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  Capitalize.firstLetterUppercase(currentUser.data.role.name),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _buildSettingsMenu(context, ref, colorScheme),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(ColorScheme colorScheme, UserModel currentUser) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        currentUser.data.firstName.isNotEmpty
            ? currentUser.data.firstName[0].toUpperCase()
            : '?',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      position: PopupMenuPosition.under,
      color: colorScheme.surfaceContainerLowest,
      onSelected: (value) {
        switch (value) {
          case 'edit_profile':
            context.push('/profile');
            break;
          case 'change_password':
            context.push('/change-password');
            break;
          case 'about':
            context.push('/about');
            break;
          case 'theme':
            context.push('/theme');
            break;
          case 'support':
            context.push('/support');
            break;
          case 'logout':
            showCustomConfirmDialog(
              context: context,
              title: 'Logout',
              description: 'Are you sure you want to end your session?',
              confirmButtonText: 'Logout',
              isDestructive: true,
              onConfirm: ref.read(authNotifierProvider.notifier).logout,
            );
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(
          'edit_profile',
          Icons.person_outline_rounded,
          'Edit Profile',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'change_password',
          Icons.password_outlined,
          'Change Password',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'theme',
          Icons.palette_outlined,
          'Theme Mode',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'support',
          Icons.support_agent_outlined,
          'Support',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'about',
          Icons.info_outline_rounded,
          'About',
          colorScheme.onSurface,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          'logout',
          Icons.logout_rounded,
          'Logout',
          colorScheme.error,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
