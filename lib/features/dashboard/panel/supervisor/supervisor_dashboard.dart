import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:hr_connect/features/reports/controllers/reports_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SupervisorDashboard extends StatefulWidget {
  final UserModel user;

  const SupervisorDashboard({super.key, required this.user});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final leaveController = context.read<LeaveController>();
        final attendanceController = context.read<AttendanceController>();
        leaveController.setCurrentUserRole(widget.user.role);
        attendanceController.fetchAttendance();
        attendanceController.fetchTodayAttendance(widget.user.uid);
        leaveController.fetchLeaves();
        context.read<ReportsController>().fetchReportData();
      }
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceController = context.read<AttendanceController>();
    final leaveController = context.read<LeaveController>();
    final reportsController = context.read<ReportsController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await attendanceController.fetchAttendance(forceRefresh: true);
            await leaveController.fetchLeaves(forceRefresh: true);
            await reportsController.fetchReportData(forceRefresh: true);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32.w : 24.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    SizedBox(height: 24.h),
                    _QuickActionsSection(
                      userId: widget.user.uid,
                      employeeName: widget.user.fullname,
                    ),
                    SizedBox(height: 24.h),
                    _buildTeamOverviewSection(theme, isWide),
                    SizedBox(height: 24.h),
                    _buildAttendanceStatsSection(theme),
                    SizedBox(height: 24.h),
                    _buildPendingApprovalsSection(theme),
                    SizedBox(height: 24.h),
                    _buildTeamActivitySection(theme),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoleBadge(label: 'SUPERVISOR', color: Colors.purple),
        SizedBox(height: 8.h),
        Text(
          _greeting,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.user.fullname,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamOverviewSection(ThemeData theme, bool isWide) {
    return Consumer<ReportsController>(
      builder: (context, controller, _) {
        final data = controller.reportData;
        final totalEmployees = data?.totalEmployees ?? 0;
        final activeEmployees = data?.activeEmployees ?? 0;
        final attendanceRate = data?.attendanceRate ?? 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Team Overview'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people_rounded,
                    iconColor: Colors.blue,
                    title: 'Team Members',
                    value: '$totalEmployees',
                    subtitle: '$activeEmployees active',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up_rounded,
                    iconColor: Colors.green,
                    title: 'Attendance',
                    value: '${attendanceRate.toStringAsFixed(1)}%',
                    subtitle: 'This period',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttendanceStatsSection(ThemeData theme) {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Attendance',
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
                  child: _MiniStatCard(
                    label: 'Present',
                    value: '${controller.presentCount}',
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Late',
                    value: '${controller.lateCount}',
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Absent',
                    value: '${controller.absentCount}',
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Leave',
                    value: '${controller.leaveCount}',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingApprovalsSection(ThemeData theme) {
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        final pendingLeaves = controller.approvableLeaves.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Approvals',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (pendingLeaves.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${pendingLeaves.length} pending',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            if (pendingLeaves.isEmpty)
              AppCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48.sp,
                          color: Colors.green,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'All caught up!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...pendingLeaves.map(
                (leave) => _PendingLeaveCard(
                  leave: leave,
                  onApprove: () => controller.approveLeave(
                    leave.id,
                    widget.user.fullname,
                    widget.user.role,
                  ),
                  onReject: () =>
                      _showRejectDialog(context, controller, leave.id),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(
    BuildContext context,
    LeaveController controller,
    String leaveId,
  ) {
    final reasonController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Leave'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: 'Enter reason for rejection',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                controller.rejectLeave(leaveId, reason, widget.user.role);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamActivitySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Team Activity',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        Consumer<AttendanceController>(
          builder: (context, controller, _) {
            final recentAttendance = controller.attendanceList.take(5).toList();

            if (recentAttendance.isEmpty) {
              return AppCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Text(
                      'No recent activity',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return AppCard(
              child: Column(
                children: recentAttendance
                    .map(
                      (att) => _ActivityItem(
                        name: att.employeeName,
                        action: att.checkOut != null
                            ? 'Checked out at ${DateFormat('HH:mm').format(att.checkOut!)}'
                            : att.checkIn != null
                            ? 'Checked in at ${DateFormat('HH:mm').format(att.checkIn!)}'
                            : att.status.name,
                        time: DateFormat('MMM d').format(att.date),
                        statusColor: _getStatusColor(att.status.name),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _RoleBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingLeaveCard extends StatelessWidget {
  final LeaveModel leave;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingLeaveCard({
    required this.leave,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                child: Text(
                  leave.employeeName.isNotEmpty ? leave.employeeName[0] : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave.employeeName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${leave.type.name} - ${DateFormat('MMM d').format(leave.startDate)} to ${DateFormat('MMM d').format(leave.endDate)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            leave.reason,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final Color statusColor;

  const _ActivityItem({
    required this.name,
    required this.action,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  action,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
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
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final todayAttendance = controller.todayAttendance;
        final hasCheckedIn = todayAttendance?.checkIn != null;
        final hasCheckedOut = todayAttendance?.checkOut != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Quick Actions'),
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
