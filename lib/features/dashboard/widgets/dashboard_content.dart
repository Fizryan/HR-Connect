import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/dashboard/models/dashboard_data.dart';
import 'package:hr_connect/features/dashboard/widgets/dashboard_header.dart';
import 'package:hr_connect/features/dashboard/widgets/dashboard_stats.dart';
import 'package:hr_connect/features/dashboard/widgets/employee_list_widget.dart';
import 'package:hr_connect/features/dashboard/widgets/section_title.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatelessWidget {
  final UserModel user;
  final DashboardData data;
  final Future<void> Function() onRefresh;

  const DashboardContent({
    super.key,
    required this.user,
    required this.data,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (user.role == UserRole.admin) {
      return _buildAdminDashboard(context);
    }
    return _buildStandardDashboard(context);
  }

  Widget _buildAdminDashboard(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(user: user),
              SizedBox(height: 16.h),
              if (data.lastUpdated != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: 14.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Last updated: ${DateFormat('HH:mm, dd MMM yyyy').format(data.lastUpdated!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _QuickActionsSection(
                userId: user.uid,
                employeeName: user.fullname,
              ),
              SizedBox(height: 24.h),
              SectionTitle(title: 'Today\'s Traffic Summary'),
              SizedBox(height: 12.h),
              _buildTrafficSummary(theme),
              SizedBox(height: 24.h),
              SectionTitle(title: 'Employee Overview'),
              SizedBox(height: 12.h),
              DashboardStats(
                totalEmployees: data.totalEmployees,
                activeCount: data.activeCount,
                inactiveCount: data.inactiveCount,
                totalRoleCount: UserRole.values.length,
              ),
              SizedBox(height: 24.h),
              SectionTitle(title: 'Leave & Attendance Stats'),
              SizedBox(height: 12.h),
              _buildLeaveAttendanceStats(theme),
              SizedBox(height: 24.h),
              SectionTitle(title: 'Recent Employees', onViewAll: () {}),
              SizedBox(height: 12.h),
              EmployeeListWidget(employees: data.recentEmployees),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficSummary(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    final gradientStart = isDark
        ? const Color(0xFF1E3A5F)
        : theme.colorScheme.primary;
    final gradientEnd = isDark
        ? const Color(0xFF2D4A6F)
        : theme.colorScheme.primary.withValues(alpha: 0.8);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : theme.colorScheme.primary.withValues(alpha: 0.3);

    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.95)
        : Colors.white;
    final subtleTextColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.8);

    final lateColor = isDark ? Colors.amber.shade300 : Colors.orange.shade200;
    final absentColor = isDark ? Colors.red.shade300 : Colors.red.shade200;
    final progressBgColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.3);
    final goodProgressColor = isDark
        ? Colors.green.shade400
        : Colors.green.shade300;
    final warningProgressColor = isDark
        ? Colors.amber.shade400
        : Colors.orange.shade300;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrafficItem(
                icon: Icons.login,
                label: 'Present Today',
                value: data.todayAttendance.toString(),
                color: textColor,
                subtleColor: subtleTextColor,
              ),
              _buildTrafficItem(
                icon: Icons.warning_amber,
                label: 'Late Arrivals',
                value: data.todayLate.toString(),
                color: lateColor,
                subtleColor: subtleTextColor,
              ),
              _buildTrafficItem(
                icon: Icons.person_off,
                label: 'Absent',
                value: data.todayAbsent.toString(),
                color: absentColor,
                subtleColor: subtleTextColor,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance Rate',
                    style: TextStyle(color: subtleTextColor, fontSize: 12.sp),
                  ),
                  Text(
                    '${data.attendanceRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: data.attendanceRate / 100,
                  backgroundColor: progressBgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    data.attendanceRate >= 80
                        ? goodProgressColor
                        : warningProgressColor,
                  ),
                  minHeight: 8.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    Color? subtleColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: subtleColor ?? Colors.white.withValues(alpha: 0.8),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveAttendanceStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            icon: Icons.pending_actions,
            label: 'Pending Leaves',
            value: data.pendingLeaveRequests.toString(),
            color: Colors.orange,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            theme,
            icon: Icons.event_available,
            label: 'Leaves This Month',
            value: data.totalLeaveThisMonth.toString(),
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardDashboard(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(user: user),
              SizedBox(height: 24.h),
              _QuickActionsSection(
                userId: user.uid,
                employeeName: user.fullname,
              ),
              SizedBox(height: 24.h),
              DashboardStats(
                totalEmployees: data.totalEmployees,
                activeCount: data.activeCount,
                inactiveCount: data.inactiveCount,
                totalRoleCount: UserRole.values.length,
              ),
              SizedBox(height: 32.h),
              SectionTitle(title: 'Employees Overview', onViewAll: () {}),
              SizedBox(height: 16.h),
              EmployeeListWidget(employees: data.recentEmployees),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final String userId;
  final String employeeName;

  const _QuickActionsSection({
    required this.userId,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final todayAttendance = controller.todayAttendance;
        final hasCheckedIn = todayAttendance?.checkIn != null;
        final hasCheckedOut = todayAttendance?.checkOut != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: hasCheckedIn ? 'Checked In' : 'Check In',
                    icon: Icons.login,
                    color: hasCheckedIn ? Colors.grey : Colors.green,
                    enabled: !hasCheckedIn,
                    onTap: () => _handleCheckIn(context, controller),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _ActionCard(
                    title: hasCheckedOut ? 'Checked Out' : 'Check Out',
                    icon: Icons.logout,
                    color: hasCheckedOut
                        ? Colors.grey
                        : (hasCheckedIn ? Colors.orange : Colors.grey),
                    enabled: hasCheckedIn && !hasCheckedOut,
                    onTap: () => _handleCheckOut(context, controller),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    AttendanceController controller,
  ) async {
    final result = await controller.checkIn(userId, employeeName: employeeName);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleCheckOut(
    BuildContext context,
    AttendanceController controller,
  ) async {
    final result = await controller.checkOut(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: enabled ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withValues(alpha: enabled ? 0.3 : 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color.withValues(alpha: enabled ? 1.0 : 0.5),
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: enabled ? 1.0 : 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
