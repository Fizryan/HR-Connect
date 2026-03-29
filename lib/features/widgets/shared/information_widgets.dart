import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationWidgets extends StatelessWidget {
  final ColorScheme colorScheme;
  final String desciption;
  final IconData icon;
  final Color iconColor;
  const InformationWidgets({
    super.key,
    required this.colorScheme,
    required this.desciption,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              desciption,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
