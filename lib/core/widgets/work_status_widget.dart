import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkStatusWidget extends StatelessWidget {
  final String userId;
  final bool compact;

  const WorkStatusWidget({
    super.key,
    required this.userId,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(compact ? 12.w : 16.w),
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
        children: [
          Row(
            children: [
              Icon(
                Icons.work_history_rounded,
                color: theme.colorScheme.primary,
                size: compact ? 18.sp : 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Work Status',
                style: TextStyle(
                  fontSize: compact ? 14.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 12.h : 16.h),
          Row(
            children: [
              Expanded(
                child: _WorkHoursCard(userId: userId, compact: compact),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _LeaveBalanceCard(userId: userId, compact: compact),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkHoursCard extends StatelessWidget {
  final String userId;
  final bool compact;

  const _WorkHoursCard({required this.userId, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final today = controller.todayAttendance;
        final checkIn = today?.checkIn;
        final checkOut = today?.checkOut;

        String hoursWorked = '0h 0m';
        double progress = 0;
        String statusText = 'Not checked in';
        Color statusColor = Colors.grey;

        if (checkIn != null) {
          final endTime = checkOut ?? DateTime.now();
          final duration = endTime.difference(checkIn);
          final hours = duration.inHours;
          final minutes = duration.inMinutes % 60;
          hoursWorked = '${hours}h ${minutes}m';

          progress = (duration.inMinutes / 480).clamp(0, 1);

          if (checkOut != null) {
            statusText = 'Day complete';
            statusColor = Colors.green;
          } else {
            statusText = 'Working...';
            statusColor = Colors.blue;
          }
        }

        return Container(
          padding: EdgeInsets.all(compact ? 10.w : 12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: compact ? 14.sp : 16.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: compact ? 10.sp : 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                hoursWorked,
                style: TextStyle(
                  fontSize: compact ? 18.sp : 22.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1 ? Colors.green : theme.colorScheme.primary,
                  ),
                  minHeight: compact ? 4.h : 6.h,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: compact ? 9.sp : 10.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (checkIn != null) ...[
                SizedBox(height: 4.h),
                Text(
                  'In: ${DateFormat('HH:mm').format(checkIn)}${checkOut != null ? ' • Out: ${DateFormat('HH:mm').format(checkOut)}' : ''}',
                  style: TextStyle(
                    fontSize: compact ? 8.sp : 9.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  final String userId;
  final bool compact;

  const _LeaveBalanceCard({required this.userId, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        final balance = controller.leaveBalance;
        final annualBalance =
            balance['annual']?['remaining'] ??
            LeaveController.defaultQuotas['annual'] ??
            12;
        final sickBalance =
            balance['sick']?['remaining'] ??
            LeaveController.defaultQuotas['sick'] ??
            6;
        final personalBalance =
            balance['personal']?['remaining'] ??
            LeaveController.defaultQuotas['personal'] ??
            2;
        final totalRemaining = annualBalance + sickBalance + personalBalance;

        return Container(
          padding: EdgeInsets.all(compact ? 10.w : 12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.withValues(alpha: 0.1),
                Colors.teal.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.beach_access,
                    size: compact ? 14.sp : 16.sp,
                    color: Colors.teal,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Leave Balance',
                    style: TextStyle(
                      fontSize: compact ? 10.sp : 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '$totalRemaining/${LeaveController.maxLeaveDaysPerYear} days',
                style: TextStyle(
                  fontSize: compact ? 18.sp : 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _LeaveTypeChip(
                    label: 'Annual',
                    count: annualBalance,
                    color: Colors.blue,
                    compact: compact,
                  ),
                  SizedBox(width: 6.w),
                  _LeaveTypeChip(
                    label: 'Sick',
                    count: sickBalance,
                    color: Colors.orange,
                    compact: compact,
                  ),
                  SizedBox(width: 6.w),
                  _LeaveTypeChip(
                    label: 'Personal',
                    count: personalBalance,
                    color: Colors.purple,
                    compact: compact,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LeaveTypeChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool compact;

  const _LeaveTypeChip({
    required this.label,
    required this.count,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.w : 8.w,
        vertical: compact ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 4.w : 6.w,
            height: compact ? 4.w : 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 4.w),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: compact ? 8.sp : 9.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkStatusCompact extends StatelessWidget {
  final String userId;

  const WorkStatusCompact({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<AttendanceController, LeaveController>(
      builder: (context, attendanceCtrl, leaveCtrl, _) {
        final today = attendanceCtrl.todayAttendance;
        final checkIn = today?.checkIn;
        final checkOut = today?.checkOut;

        String hoursWorked = '0h';
        if (checkIn != null) {
          final endTime = checkOut ?? DateTime.now();
          final duration = endTime.difference(checkIn);
          hoursWorked = '${duration.inHours}h ${duration.inMinutes % 60}m';
        }

        final balance = leaveCtrl.leaveBalance;
        final annualBalance =
            balance['annual']?['remaining'] ??
            LeaveController.defaultQuotas['annual'] ??
            12;
        final sickBalance =
            balance['sick']?['remaining'] ??
            LeaveController.defaultQuotas['sick'] ??
            6;
        final personalBalance =
            balance['personal']?['remaining'] ??
            LeaveController.defaultQuotas['personal'] ??
            2;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      hoursWorked,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      ' today',
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
              Container(
                width: 1,
                height: 20.h,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.beach_access, size: 16.sp, color: Colors.teal),
                    SizedBox(width: 6.w),
                    Text(
                      '${annualBalance + sickBalance + personalBalance}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      ' days left',
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
        );
      },
    );
  }
}
