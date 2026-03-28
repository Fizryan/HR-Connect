import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/widgets/admin_dashboard.dart';
import 'package:hr_connect/core/widgets/shared/header.dart';

class MainScreen extends StatefulWidget {
  final UserRole role;

  const MainScreen({
    super.key,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(colorScheme: colorScheme, name: 'Fizryan', role: UserRole.admin), // TODO: Replace with actual data
            SizedBox(height: 16.h),
            _buildDashboardContent(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ColorScheme colorScheme) {
    switch (widget.role) {
      case UserRole.admin:
        return AdminDashboard.buildAdminDashboard(colorScheme);
      default:
        return const SizedBox.shrink();
    }
  }
}