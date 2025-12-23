import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:hr_connect/features/leave/views/leave_request_form.dart';
import 'package:hr_connect/features/leave/views/leave_management_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';

class LeaveRequestView extends StatefulWidget {
  const LeaveRequestView({super.key});

  @override
  State<LeaveRequestView> createState() => _LeaveRequestViewState();
}

class _LeaveRequestViewState extends State<LeaveRequestView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().user!.uid;
      context.read<LeaveController>().fetchLeaveBalance(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<LeaveController>(
          builder: (context, controller, _) {
            return RefreshIndicator(
              onRefresh: () async {
                final userId = context.read<AuthController>().user!.uid;
                await controller.fetchLeaveBalance(userId);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      title: 'Leave Request',
                      subtitle: 'Submit and track your leave requests',
                    ),
                    SizedBox(height: 16.h),
                    _buildLeaveBalance(theme),
                    SizedBox(height: 24.h),
                    _buildMyRequests(context, theme, controller),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLeaveRequestDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Request Leave'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildLeaveBalance(ThemeData theme) {
    final controller = context.read<LeaveController>();
    final leaveBalance = controller.leaveBalance;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Total: ${controller.totalRemainingDays}/${LeaveController.maxLeaveDaysPerYear} days',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _BalanceCard(
                  type: 'Annual',
                  remaining: leaveBalance['annual']?['remaining'] ?? 12,
                  total: leaveBalance['annual']?['total'] ?? 12,
                  color: Colors.blue,
                ),
                SizedBox(width: 12.w),
                _BalanceCard(
                  type: 'Sick',
                  remaining: leaveBalance['sick']?['remaining'] ?? 6,
                  total: leaveBalance['sick']?['total'] ?? 6,
                  color: Colors.red,
                ),
                SizedBox(width: 12.w),
                _BalanceCard(
                  type: 'Personal',
                  remaining: leaveBalance['personal']?['remaining'] ?? 2,
                  total: leaveBalance['personal']?['total'] ?? 2,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequests(
    BuildContext context,
    ThemeData theme,
    LeaveController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Requests',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${controller.myLeaveList.length} requests',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (controller.isLoading)
            const LoadingState(message: 'Loading your requests...')
          else if (controller.myLeaveList.isEmpty)
            const EmptyState(
              icon: Icons.event_available,
              title: 'No leave requests yet',
              subtitle:
                  'Tap the button below to submit your first leave request',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.myLeaveList.length,
              itemBuilder: (context, index) {
                final leave = controller.myLeaveList[index];
                return _LeaveRequestCard(
                  leave: leave,
                  onEdit: () =>
                      _showLeaveRequestDialog(context, existingLeave: leave),
                  onCancel: () => _showCancelDialog(context, leave),
                );
              },
            ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  void _showLeaveRequestDialog(
    BuildContext context, {
    LeaveModel? existingLeave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeaveRequestForm(existingLeave: existingLeave),
    );
  }

  void _showCancelDialog(BuildContext context, LeaveModel leave) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text(
          'Are you sure you want to cancel this leave request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LeaveController>().cancelLeave(leave.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave request cancelled')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String type;
  final int remaining;
  final int total;
  final Color color;

  const _BalanceCard({
    required this.type,
    required this.remaining,
    required this.total,
    required this.color,
  });

  IconData get _icon {
    switch (type.toLowerCase()) {
      case 'annual':
        return Icons.beach_access;
      case 'sick':
        return Icons.medical_services;
      case 'personal':
        return Icons.person;
      case 'unpaid':
        return Icons.money_off;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(_icon, color: color, size: 20.sp),
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
            'of $total',
            style: TextStyle(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            type,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaveRequestCard extends StatelessWidget {
  final LeaveModel leave;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const _LeaveRequestCard({
    required this.leave,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = LeaveColors.getStatusColor(leave.status);
    final typeColor = LeaveColors.getTypeColor(leave.type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(statusColor, typeColor),
                SizedBox(height: 12.h),
                _buildDateInfo(theme),
                SizedBox(height: 8.h),
                Text(
                  leave.reason,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (leave.status == LeaveStatus.rejected &&
                    leave.rejectionReason != null)
                  _buildRejectionInfo(),
                if (leave.status == LeaveStatus.approved &&
                    leave.approvedBy != null)
                  _buildApprovalInfo(),
              ],
            ),
          ),
          if (leave.status == LeaveStatus.pending) _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(Color statusColor, Color typeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusBadge(label: leave.typeText, color: typeColor),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getStatusIcon(), size: 12.sp, color: statusColor),
            SizedBox(width: 4.w),
            StatusBadge(label: leave.statusText, color: statusColor),
          ],
        ),
      ],
    );
  }

  IconData _getStatusIcon() {
    switch (leave.status) {
      case LeaveStatus.pending:
        return Icons.hourglass_empty;
      case LeaveStatus.approved:
        return Icons.check_circle;
      case LeaveStatus.rejected:
        return Icons.cancel;
      case LeaveStatus.cancelled:
        return Icons.do_not_disturb;
    }
  }

  Widget _buildDateInfo(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16.sp,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        SizedBox(width: 8.w),
        Text(
          '${DateFormat('MMM d').format(leave.startDate)} - ${DateFormat('MMM d, yyyy').format(leave.endDate)}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 8.w),
        StatusBadge(
          label: '${leave.days} days',
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildRejectionInfo() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 14.sp, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Reason: ${leave.rejectionReason}',
              style: TextStyle(fontSize: 11.sp, color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        'Approved by ${leave.approvedBy}',
        style: TextStyle(fontSize: 10.sp, color: Colors.green.shade700),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onEdit,
              icon: Icon(Icons.edit, size: 16.sp),
              label: const Text('Edit'),
            ),
          ),
          Container(
            width: 1,
            height: 30.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onCancel,
              icon: Icon(Icons.close, size: 16.sp, color: Colors.red),
              label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
