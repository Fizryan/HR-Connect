import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';

class MenuWidgets extends StatelessWidget {
  final ColorScheme colorScheme;
  final List<ListMenu> menus;
  final String title;
  final IconData icon;
  const MenuWidgets({
    super.key,
    required this.colorScheme,
    required this.title,
    required this.menus,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(icon, color: colorScheme.onSurface, size: 24.sp)
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Wrap(
              spacing: 16.w,
              runSpacing: 24.h,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: menus.map((menu) => SizedBox(
                width: (MediaQuery.of(context).size.width - 130.w) / 5,
                child: _buildMenuIcon(menu),
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuIcon(ListMenu menu) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to the corresponding screen
        debugPrint('Tapped on ${menu.title}');
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  shape: BoxShape.circle
                ),
                child: Icon(menu.icon, color: menu.iconColor, size: 24.sp),
              ),
              if (menu.isNew)
                Positioned(
                  top: -6.h,
                  right: -6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'New',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            menu.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12.sp,
              height: 1.2,
              fontWeight: FontWeight.w500,
            )
          )
        ]
      ),
    );
  }
}
