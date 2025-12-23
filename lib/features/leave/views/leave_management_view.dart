import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveManagementView extends StatefulWidget {
  final UserModel user;

  const LeaveManagementView({super.key, required this.user});

  @override
  State<LeaveManagementView> createState() => _LeaveManagementViewState();
}

class _LeaveManagementViewState extends State<LeaveManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<LeaveController>();
      controller.setCurrentUserRole(widget.user.role);
      controller.fetchLeaves();
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
              title: 'Leave Management',
              subtitle: 'Review and manage leave requests',
            ),
            SizedBox(height: 8.h),
            _buildStats(context),
            SizedBox(height: 16.h),
            _buildFilterChips(context),
            SizedBox(height: 16.h),
            _buildSearchBar(context),
            SizedBox(height: 16.h),
            Expanded(child: _buildLeaveList(context, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        return StatCardRow(
          stats: [
            StatCardData(
              label: 'Pending',
              count: controller.pendingCount,
              color: Colors.orange,
            ),
            StatCardData(
              label: 'Approved',
              count: controller.approvedCount,
              color: Colors.green,
            ),
            StatCardData(
              label: 'Rejected',
              count: controller.rejectedCount,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        return AppFilterChips(
          filters: const ['All', 'Pending', 'Approved', 'Rejected'],
          currentFilter: controller.currentFilter,
          onFilterChanged: controller.setFilter,
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      hintText: 'Search by employee name...',
      onChanged: (value) {
        context.read<LeaveController>().setSearchQuery(value);
      },
    );
  }

  Widget _buildLeaveList(BuildContext context, ThemeData theme) {
    return Consumer<LeaveController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const LoadingState(message: 'Loading leave requests...');
        }

        if (controller.leaveList.isEmpty) {
          return const EmptyState(
            icon: Icons.beach_access,
            title: 'No leave requests',
            subtitle: 'No requests matching your filters',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchLeaves(forceRefresh: true),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: controller.leaveList.length,
            itemBuilder: (context, index) {
              final leave = controller.leaveList[index];
              return _LeaveCard(
                leave: leave,
                currentUserRole: widget.user.role,
                onApprove: () => controller.approveLeave(
                  leave.id,
                  widget.user.fullname,
                  widget.user.role,
                ),
                onReject: (reason) =>
                    controller.rejectLeave(leave.id, reason, widget.user.role),
              );
            },
          ),
        );
      },
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveModel leave;
  final UserRole currentUserRole;
  final VoidCallback onApprove;
  final Function(String) onReject;

  const _LeaveCard({
    required this.leave,
    required this.currentUserRole,
    required this.onApprove,
    required this.onReject,
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
                _buildHeader(theme, typeColor, statusColor),
                SizedBox(height: 12.h),
                _buildDateRow(theme),
                SizedBox(height: 8.h),
                Text(
                  leave.reason,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (leave.rejectionReason != null) _buildRejectionInfo(),
              ],
            ),
          ),
          if (leave.status == LeaveStatus.pending)
            _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color typeColor, Color statusColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: typeColor.withValues(alpha: 0.1),
          child: Text(
            leave.employeeName.isNotEmpty
                ? leave.employeeName[0].toUpperCase()
                : '?',
            style: TextStyle(color: typeColor, fontWeight: FontWeight.bold),
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
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              StatusBadge(label: leave.typeText, color: typeColor),
            ],
          ),
        ),
        StatusBadge(label: leave.statusText, color: statusColor),
      ],
    );
  }

  Widget _buildDateRow(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14.sp,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        SizedBox(width: 8.w),
        Text(
          '${DateFormat('dd MMM').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 12.w),
        StatusBadge(
          label: '${leave.days} day${leave.days > 1 ? 's' : ''}',
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
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 14.sp, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Rejected: ${leave.rejectionReason}',
              style: TextStyle(fontSize: 11.sp, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    final canApprove = leave.canBeApprovedBy(currentUserRole);

    if (!canApprove) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 14.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: 8.w),
            Text(
              'Requires approval from ${leave.requiredApproverText}',
              style: TextStyle(
                fontSize: 11.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

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
              onPressed: () => _showRejectDialog(context),
              icon: Icon(Icons.close, size: 18.sp, color: Colors.red),
              label: const Text('Reject', style: TextStyle(color: Colors.red)),
            ),
          ),
          Container(
            width: 1,
            height: 40.h,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onApprove,
              icon: Icon(Icons.check, size: 18.sp, color: Colors.green),
              label: const Text(
                'Approve',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Reject Leave Request',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Reason for rejection',
            labelStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                onReject(reasonController.text);
                Navigator.pop(ctx);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class LeaveColors {
  static Color getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      case LeaveStatus.cancelled:
        return Colors.grey;
    }
  }

  static Color getTypeColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return Colors.blue;
      case LeaveType.sick:
        return Colors.red;
      case LeaveType.personal:
        return Colors.purple;
      case LeaveType.maternity:
        return Colors.pink;
      case LeaveType.paternity:
        return Colors.teal;
      case LeaveType.unpaid:
        return Colors.grey;
    }
  }
}
