import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/attendance/models/attendance_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceController>().fetchAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Attendance',
              subtitle: 'Track employee attendance',
            ),
            SizedBox(height: 8.h),
            _buildDateSelector(context),
            SizedBox(height: 16.h),
            _buildStats(context),
            SizedBox(height: 16.h),
            _buildSearchBar(context),
            SizedBox(height: 16.h),
            Expanded(child: _buildAttendanceList(context, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        return DateSelector(
          selectedDate: controller.selectedDate,
          onDateChanged: controller.setSelectedDate,
          lastDate: DateTime.now(),
        );
      },
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        return StatCardRow(
          compact: true,
          stats: [
            StatCardData(
              label: 'Present',
              count: controller.presentCount,
              color: Colors.green,
            ),
            StatCardData(
              label: 'Absent',
              count: controller.absentCount,
              color: Colors.red,
            ),
            StatCardData(
              label: 'Late',
              count: controller.lateCount,
              color: Colors.orange,
            ),
            StatCardData(
              label: 'Leave',
              count: controller.leaveCount,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      hintText: 'Search employee...',
      onChanged: (value) {
        context.read<AttendanceController>().setSearchQuery(value);
      },
    );
  }

  Widget _buildAttendanceList(BuildContext context, ThemeData theme) {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const LoadingState(message: 'Loading attendance...');
        }

        if (controller.attendanceList.isEmpty) {
          return const EmptyState(
            icon: Icons.event_busy,
            title: 'No attendance records',
            subtitle: 'No attendance data for this date',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAttendance(forceRefresh: true),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: controller.attendanceList.length,
            itemBuilder: (context, index) {
              final attendance = controller.attendanceList[index];
              return _AttendanceCard(attendance: attendance);
            },
          ),
        );
      },
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final AttendanceModel attendance;

  const _AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(attendance.status);

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: statusColor.withValues(alpha: 0.1),
            child: Text(
              attendance.employeeName.isNotEmpty
                  ? attendance.employeeName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendance.employeeName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildTimeRow(theme),
                if (attendance.notes?.isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      attendance.notes!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          StatusBadge(label: attendance.statusText, color: statusColor),
        ],
      ),
    );
  }

  Widget _buildTimeRow(ThemeData theme) {
    return Row(
      children: [
        if (attendance.checkIn != null) ...[
          Icon(Icons.login, size: 14.sp, color: Colors.green),
          SizedBox(width: 4.w),
          Text(
            DateFormat('HH:mm').format(attendance.checkIn!),
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        if (attendance.checkOut != null) ...[
          Icon(Icons.logout, size: 14.sp, color: Colors.red),
          SizedBox(width: 4.w),
          Text(
            DateFormat('HH:mm').format(attendance.checkOut!),
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.leave:
        return Colors.blue;
      case AttendanceStatus.halfDay:
        return Colors.purple;
    }
  }
}
