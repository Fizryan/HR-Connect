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
    
    final resolvedIconColor = iconColor ?? colorScheme.onSurface;
    final resolvedTextColor = textColor ?? colorScheme.onSurface;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        tileColor: backgroundColor ?? 
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        leading: Icon(icon, color: resolvedIconColor),
        title: Text(
          title,
          style: TextStyle(
            color: resolvedTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: resolvedIconColor.withValues(alpha: 0.5),
        ),
        splashColor: (backgroundColor ?? colorScheme.primary).withValues(alpha: 0.1),
        onTap: onTap,
      ),
    );
  }
}