import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/support_information.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class DialogWidget {
  static final String _supportEmail = SupportInformation.supportEmail;
  static final String _supportPhone = SupportInformation.supportPhone;

  static void showSupportDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.support_agent_outlined,
              color: colorScheme.onSecondary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('Need IT Support?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Just contacting the HR Administrator or IT Support:',
              style: TextStyle(
                color: colorScheme.onSecondary.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(Icons.email, size: 18.sp, color: colorScheme.onSecondary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _supportEmail,
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.phone_in_talk_outlined,
                  size: 18.sp,
                  color: colorScheme.onSecondary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _supportPhone,
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: colorScheme.onSecondary)),
          ),
        ],
      ),
    );
  }

  static void showAboutDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colorScheme.onSecondary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('About'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HR-Connect is a modern human resources management system designed to streamline corporate operations. Ensuring that every HR workflow from daily operations remains efficient, secure, and centralized.',
              style: TextStyle(color: colorScheme.onSecondary),
            ),
            SizedBox(height: 14.h),
            Text(
              'Team: HHHM',
              style: TextStyle(
                color: colorScheme.onSecondary.withValues(alpha: 0.6),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final versionStr = snapshot.hasData
                    ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                    : 'Loading...';
                return Text(
                  'Version: $versionStr',
                  style: TextStyle(
                    color: colorScheme.onSecondary.withValues(alpha: 0.6),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: colorScheme.onSecondary)),
          ),
        ],
      ),
    );
  }

  static void showLogoutDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_outlined,
              color: colorScheme.onSecondary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('Logout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                color: colorScheme.onSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.onSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout_outlined, size: 18),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error.withValues(alpha: 0.8),
              foregroundColor: colorScheme.onError,
            ),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  static void showThemeDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return AlertDialog(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.color_lens_outlined,
                    color: colorScheme.onSecondary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  const Text('Select Theme'),
                ],
              ),
              content: RadioGroup<ThemeMode>(
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      value: ThemeMode.system,
                      activeColor: colorScheme.onSecondary,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      value: ThemeMode.light,
                      activeColor: colorScheme.onSecondary,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      value: ThemeMode.dark,
                      activeColor: colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: TextStyle(color: colorScheme.onSecondary)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
