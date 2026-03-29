import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HeaderWidgets extends StatelessWidget {
  final ColorScheme colorScheme;
  final String name;
  final UserRole role;

  const HeaderWidgets({
    super.key,
    required this.colorScheme,
    required this.name,
    required this.role,
  });

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorScheme.primary,
            radius: 20.r,
            child: Text(
              role.name[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      'HRConnect | ${_capitalize(role.name)}',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.verified,
                      color: colorScheme.onSurface,
                      size: 14.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              colorScheme.brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}
