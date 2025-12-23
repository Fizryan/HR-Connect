import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployeeDashboard extends StatefulWidget {
  final UserModel user;

  const EmployeeDashboard({super.key, required this.user});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AttendanceController>().fetchTodayAttendance(
          widget.user.uid,
        );
        context.read<LeaveController>().fetchLeaveBalance(widget.user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceController = context.read<AttendanceController>();
    final leaveController = context.read<LeaveController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await attendanceController.fetchTodayAttendance(widget.user.uid);
            await leaveController.fetchLeaveBalance(widget.user.uid);
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
                    _TodayStatusCard(userId: widget.user.uid),
                    SizedBox(height: 24.h),
                    _LeaveBalanceSection(userId: widget.user.uid),
                    SizedBox(height: 24.h),
                    _RecentActivitySection(userId: widget.user.uid),
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

class _TodayStatusCard extends StatelessWidget {
  final String userId;

  const _TodayStatusCard({required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final attendance = controller.todayAttendance;
        final checkInTime = attendance?.checkIn;
        final checkOutTime = attendance?.checkOut;

        String workHours = '--:--';
        if (checkInTime != null) {
          final endTime = checkOutTime ?? DateTime.now();
          final duration = endTime.difference(checkInTime);
          final hours = duration.inHours;
          final minutes = duration.inMinutes % 60;
          workHours = '${hours}h ${minutes}m';
        }

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Status',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (controller.isLoading)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _StatusItem(
                      label: 'Check In',
                      value: checkInTime != null
                          ? DateFormat('hh:mm a').format(checkInTime)
                          : '--:-- --',
                      icon: Icons.login,
                      color: checkInTime != null ? Colors.green : Colors.grey,
                    ),
                  ),
                  _buildDivider(theme),
                  Expanded(
                    child: _StatusItem(
                      label: 'Check Out',
                      value: checkOutTime != null
                          ? DateFormat('hh:mm a').format(checkOutTime)
                          : '--:-- --',
                      icon: Icons.logout,
                      color: checkOutTime != null ? Colors.orange : Colors.grey,
                    ),
                  ),
                  _buildDivider(theme),
                  Expanded(
                    child: _StatusItem(
                      label: 'Work Hours',
                      value: workHours,
                      icon: Icons.access_time,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 50.h,
      color: theme.colorScheme.outline.withValues(alpha: 0.2),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
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
    );
  }
}

class _LeaveBalanceSection extends StatelessWidget {
  final String userId;

  const _LeaveBalanceSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        final balance = controller.leaveBalance;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leave Balance',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (controller.isLoading)
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _LeaveCard(
                    type: 'Annual',
                    remaining: balance['annual']?['remaining'] ?? 12,
                    total: balance['annual']?['total'] ?? 15,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _LeaveCard(
                    type: 'Sick',
                    remaining: balance['sick']?['remaining'] ?? 5,
                    total: balance['sick']?['total'] ?? 10,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _LeaveCard(
                    type: 'Personal',
                    remaining: balance['personal']?['remaining'] ?? 2,
                    total: balance['personal']?['total'] ?? 3,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final String type;
  final int remaining;
  final int total;
  final Color color;

  const _LeaveCard({
    required this.type,
    required this.remaining,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '$remaining',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'of $total days',
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final String userId;

  const _RecentActivitySection({required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        final recentLeaves = controller.leaves.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            if (recentLeaves.isEmpty)
              _ActivityItem(
                activity: _Activity(
                  'No Recent Activity',
                  'Your activity will appear here',
                  Icons.history,
                  Colors.grey,
                  '',
                ),
              )
            else
              ...recentLeaves.map(
                (leave) => _ActivityItem(
                  activity: _Activity(
                    _getLeaveActivityTitle(leave.status.name),
                    '${leave.typeText}: ${DateFormat('MMM d').format(leave.startDate)} - ${DateFormat('MMM d').format(leave.endDate)}',
                    _getLeaveActivityIcon(leave.status.name),
                    _getLeaveActivityColor(leave.status.name),
                    _formatTimeAgo(leave.createdAt),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getLeaveActivityTitle(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Leave Approved';
      case 'rejected':
        return 'Leave Rejected';
      case 'pending':
        return 'Leave Pending';
      default:
        return 'Leave Request';
    }
  }

  IconData _getLeaveActivityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.send;
    }
  }

  Color _getLeaveActivityColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}

class _Activity {
  final String title, subtitle, time;
  final IconData icon;
  final Color color;

  _Activity(this.title, this.subtitle, this.icon, this.color, this.time);
}

class _ActivityItem extends StatelessWidget {
  final _Activity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(activity.icon, color: activity.color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  activity.subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
