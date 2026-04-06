import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';
import 'package:hr_connect/features/widgets/model/list_overview.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

class StaffDashboard extends StatelessWidget {
  final ColorScheme colorScheme;

  const StaffDashboard({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionCard(
          title: 'Check In',
          icon: Icons.fingerprint,
          iconColor: Colors.blue,
          colorScheme: colorScheme,
        ),
        SizedBox(height: 24.h),
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        OverviewWidgets(
          title: 'My Overview',
          listOverview: [
            ListOverview(
                title: 'Present',
                subtitle: '18 Days',
                icon: Icons.check_circle,
                iconColor: Colors.green),
            ListOverview(
                title: 'Leave', subtitle: '2 Days', icon: Icons.beach_access, iconColor: Colors.blue),
            ListOverview(
                title: 'Overtime', subtitle: '12 Hours', icon: Icons.access_time, iconColor: Colors.orange),
            ListOverview(
                title: 'Bonus',
                subtitle: '\$120 Earned',
                icon: Icons.monetization_on,
                iconColor: Colors.purple),
          ],
          colorScheme: colorScheme,
        ),
        SizedBox(height: 24.h),
        MenuWidgets(
          title: 'Quick Actions',
          icon: Icons.flash_on,
          menus: [
            ListMenu(
                title: 'Attendance',
                icon: Icons.calendar_today,
                iconColor: Colors.blue, onTap: () {}),
            ListMenu(
                title: 'Leave', icon: Icons.beach_access, iconColor: Colors.orange, onTap: () {}),
            ListMenu(
                title: 'Overtime', icon: Icons.access_time, iconColor: Colors.green, onTap: () {}),
            ListMenu(
                title: 'Payroll', icon: Icons.attach_money, iconColor: Colors.purple, onTap: () {}),
          ],
          colorScheme: colorScheme,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
