import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

class SupervisorDashboard extends StatelessWidget {
  final ColorScheme colorScheme;

  const SupervisorDashboard({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Ops & Shifts',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        // Supervisor Dashboard UI
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
            child: Icon(Icons.people_outline, color: colorScheme.secondary),
          ),
          title: Text('Team Attendance', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
          subtitle: Text('12 / 15 Present Today', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: const Text('View All'),
          ),
        ),
        SizedBox(height: 24.h),
        MenuWidgets(
          title: 'Operations',
          icon: Icons.dashboard,
          menus: [
            ListMenu(title: 'Shifts', icon: Icons.schedule, iconColor: Colors.blueGrey, onTap: () {}),
            ListMenu(title: 'Leaves', icon: Icons.event_busy, iconColor: Colors.amber, onTap: () {}),
            ListMenu(title: 'Overtime', icon: Icons.more_time, iconColor: Colors.deepOrange, onTap: () {}),
            ListMenu(title: 'Reports', icon: Icons.bar_chart, iconColor: Colors.green, onTap: () {}),
          ],
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}
