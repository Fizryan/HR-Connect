import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.onSurfaceVariant;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;

    return Material(
      color: effectiveBackgroundColor,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias, 
      child: InkWell(
        onTap: onTap,
        splashColor: colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: colorScheme.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: effectiveIconColor,
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: effectiveIconColor.withValues(alpha: 0.5),
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}