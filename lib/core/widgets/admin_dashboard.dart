import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/shared/action_card.dart';

class AdminDashboard {
  static Widget buildAdminDashboard(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: colorScheme.onSurface)),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.5,
            children: [
              ActionCard(colorScheme: colorScheme, title: 'Manage Users', icon: Icons.people, iconColor: colorScheme.onSurface),
              ActionCard(colorScheme: colorScheme, title: 'Approve Leave', icon: Icons.fact_check_outlined, iconColor: colorScheme.onSurface),
              ActionCard(colorScheme: colorScheme, title: 'Reports', icon: Icons.analytics_outlined, iconColor: colorScheme.onSurface)
            ],
          )
        ],
      ),
    );
  }
}