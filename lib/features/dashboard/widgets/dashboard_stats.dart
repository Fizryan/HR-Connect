import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';

class DashboardStats extends StatelessWidget {
  final int totalEmployees;
  final int activeCount;
  final int inactiveCount;
  final int totalRoleCount;

  const DashboardStats({
    super.key,
    required this.totalEmployees,
    required this.activeCount,
    required this.inactiveCount,
    required this.totalRoleCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Employees',
          totalEmployees.toString(),
          Icons.people_outline,
          theme.colorScheme.primary,
          theme,
        ),
        _buildStatCard(
          'Inactive Users',
          inactiveCount.toString(),
          Icons.person_off_outlined,
          theme.colorScheme.error,
          theme,
        ),
        _buildStatCard(
          'Active Now',
          activeCount.toString(),
          Icons.work_outline,
          AppColors.success,
          theme,
        ),
        _buildStatCard(
          'Total Role',
          totalRoleCount.toString(),
          Icons.person_2_outlined,
          theme.colorScheme.secondary,
          theme,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(icon, color: color, size: 24.sp)],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
