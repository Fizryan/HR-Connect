import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';

class Header extends StatelessWidget {
  final ColorScheme colorScheme;
  final String name;
  final UserRole role;

  const Header({
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
            backgroundColor: colorScheme.surface,
            radius: 20.r,
            child: Text(
              role.name[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
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
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () {
              // TODO: Implement settings functionality
            },
          ),
          SizedBox(width: 8.w),
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
