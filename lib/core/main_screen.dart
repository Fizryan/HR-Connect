import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/widgets/dashboard.dart';
import 'package:hr_connect/features/widgets/shared/header.dart';

class MainScreen extends StatefulWidget {
  final UserRole role;

  const MainScreen({super.key, required this.role});

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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  colorScheme: colorScheme,
                  name: 'User',
                  role: widget.role,
                ), // TODO : Change to actual user data
                SizedBox(height: 16.h),
                _buildDashboardContent(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ColorScheme colorScheme) {
    switch (widget.role) {
      case UserRole.admin:
        return AdminDashboard(colorScheme: colorScheme);
      default:
        return const SizedBox.shrink();
    }
  }
}
