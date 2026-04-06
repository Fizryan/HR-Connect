import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

class DirectorDashboard extends StatelessWidget {
  final ColorScheme colorScheme;

  const DirectorDashboard({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Director Overview',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        // Simplified Director Dashboard UI
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Performance Report',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'View high-level overview of company goals, financial KPIs, and departmental progresses.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        MenuWidgets(
          title: 'Management',
          icon: Icons.dashboard,
          menus: [
            ListMenu(title: 'Strategy', icon: Icons.insights, iconColor: Colors.blue, onTap: () {}),
            ListMenu(title: 'Reports', icon: Icons.analytics, iconColor: Colors.purple, onTap: () {}),
            ListMenu(title: 'Approvals', icon: Icons.fact_check, iconColor: Colors.orange, onTap: () {}),
            ListMenu(title: 'Meetings', icon: Icons.groups, iconColor: Colors.teal, onTap: () {}),
          ],
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}
