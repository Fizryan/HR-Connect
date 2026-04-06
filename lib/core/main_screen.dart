import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/widgets/dashboard_widgets.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final role = widget.user.role;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidgets(
                  colorScheme: colorScheme,
                  name: widget.user.firstName,
                  role: role,
                ),
                SizedBox(height: 16.h),
                _buildDashboardContent(colorScheme, role),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ColorScheme colorScheme, UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AdminDashboard(colorScheme: colorScheme);
      case UserRole.director:
        return DirectorDashboard(colorScheme: colorScheme);
      case UserRole.manager:
        return ManagerDashboard(colorScheme: colorScheme);
      case UserRole.supervisor:
        return SupervisorDashboard(colorScheme: colorScheme);
      case UserRole.staff:
        return StaffDashboard(colorScheme: colorScheme);
    }
  }
}
