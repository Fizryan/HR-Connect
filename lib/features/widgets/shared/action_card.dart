import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionCard extends StatelessWidget {
  final ColorScheme colorScheme;
  final String title;
  final IconData icon;
  final Color iconColor;

  const ActionCard({
    super.key,
    required this.colorScheme,
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}