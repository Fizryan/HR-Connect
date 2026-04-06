import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

class ManagerDashboard extends StatelessWidget {
  final ColorScheme colorScheme;

  const ManagerDashboard({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department Analytics',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        // Simplified Manager Dashboard UI
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 28.sp),
                    SizedBox(height: 8.h),
                    Text('On Track', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    Text('15 Projects', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12.sp)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pending_actions, color: Colors.amber, size: 28.sp),
                    SizedBox(height: 8.h),
                    Text('Review', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    Text('4 Pending', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12.sp)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        MenuWidgets(
          title: 'Management',
          icon: Icons.dashboard,
          menus: [
            ListMenu(title: 'Team', icon: Icons.people, iconColor: Colors.indigo, onTap: () {}),
            ListMenu(title: 'Tasks', icon: Icons.assignment, iconColor: Colors.deepPurple, onTap: () {}),
            ListMenu(title: 'Requests', icon: Icons.request_quote, iconColor: Colors.brown, onTap: () {}),
            ListMenu(title: 'Reviews', icon: Icons.rate_review, iconColor: Colors.red, onTap: () {}),
          ],
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}
