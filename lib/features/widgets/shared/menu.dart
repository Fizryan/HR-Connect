import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';

class Menu extends StatelessWidget {
  final ColorScheme colorScheme;
  const Menu({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final List<ListMenu> menus = [
      ListMenu(title: 'User Management', icon: Icons.mode_edit_outline_outlined, iconColor: colorScheme.onSurface, isNew: true)
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(color: colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Admin Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(Icons.admin_panel_settings_outlined, color: colorScheme.onSurface, size: 24.sp)
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_outlined, color: colorScheme.onSurface, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('Caution with this features.', style: TextStyle(color: colorScheme.onSurface, fontSize: 12.sp)),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // TODO: Add Features Menu List
        ],
      ),
    );
  }
}