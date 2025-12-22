import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:hr_connect/features/reimbursement/controllers/reimbursement_controller.dart';
import 'package:hr_connect/features/reimbursement/models/reimbursement_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReimbursementManagementView extends StatefulWidget {
  const ReimbursementManagementView({super.key});

  @override
  State<ReimbursementManagementView> createState() =>
      _ReimbursementManagementViewState();
}

class _ReimbursementManagementViewState
    extends State<ReimbursementManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReimbursementController>().fetchReimbursements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<ReimbursementController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const PageHeader(
                  title: 'Reimbursements',
                  subtitle: 'Manage expense claims',
                ),
                SizedBox(height: 8.h),
                _buildStats(context, controller),
                SizedBox(height: 16.h),
                _buildFilterChips(context, controller),
                SizedBox(height: 16.h),
                _buildSearchBar(context, controller),
                SizedBox(height: 16.h),
                Expanded(child: _buildReimbursementList(context, controller)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, ReimbursementController controller) {
    return StatCardRow(
      compact: true,
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
          label: 'Paid',
          count: controller.paidCount,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    ReimbursementController controller,
  ) {
    return AppFilterChips(
      filters: const ['All', 'Pending', 'Approved', 'Paid', 'Rejected'],
      currentFilter: controller.currentFilter,
      onFilterChanged: controller.setFilter,
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ReimbursementController controller,
  ) {
    return AppSearchBar(
      hintText: 'Search by name or description...',
      onChanged: controller.setSearchQuery,
    );
  }

  Widget _buildReimbursementList(
    BuildContext context,
    ReimbursementController controller,
  ) {
    if (controller.isLoading && controller.reimbursements.isEmpty) {
      return const LoadingState(message: 'Loading reimbursements...');
    }

    if (controller.reimbursements.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long,
        title: 'No reimbursement requests',
        subtitle: 'All caught up!',
      );
    }

    final currentUser = context.read<AuthController>().user;

    return RefreshIndicator(
      onRefresh: () => controller.fetchReimbursements(forceRefresh: true),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: controller.reimbursements.length,
        itemBuilder: (context, index) {
          final reimbursement = controller.reimbursements[index];
          final isOwnRequest = currentUser?.uid == reimbursement.uid;
          return _ReimbursementManageCard(
            reimbursement: reimbursement,
            isOwnRequest: isOwnRequest,
            onApprove: () => _showApproveDialog(context, reimbursement),
            onReject: () => _showRejectDialog(context, reimbursement),
            onMarkPaid: () => _markAsPaid(context, reimbursement),
          );
        },
      ),
    );
  }

  Future<void> _showApproveDialog(
    BuildContext context,
    ReimbursementModel reimbursement,
  ) async {
    final theme = Theme.of(context);
    final controller = context.read<ReimbursementController>();
    final user = context.read<AuthController>().user;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Approve Reimbursement'),
        content: Text(
          'Approve ${reimbursement.employeeName}\'s claim of Rp ${NumberFormat('#,###').format(reimbursement.amount)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await controller.approveReimbursement(
        reimbursement.id,
        user?.fullname ?? 'Finance',
      );

      if (mounted && success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Reimbursement approved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _showRejectDialog(
    BuildContext context,
    ReimbursementModel reimbursement,
  ) async {
    final theme = Theme.of(context);
    final controller = context.read<ReimbursementController>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final reasonController = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Reject Reimbursement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Why are you rejecting this claim?'),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, reasonController.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty && mounted) {
      final success = await controller.rejectReimbursement(
        reimbursement.id,
        reason,
      );

      if (mounted && success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Reimbursement rejected'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markAsPaid(
    BuildContext context,
    ReimbursementModel reimbursement,
  ) async {
    final theme = Theme.of(context);
    final controller = context.read<ReimbursementController>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Mark as Paid'),
        content: Text(
          'Confirm payment of Rp ${NumberFormat('#,###').format(reimbursement.amount)} to ${reimbursement.employeeName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Confirm Paid'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await controller.markAsPaid(reimbursement.id);

      if (mounted && success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Marked as paid'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }
}

class _ReimbursementManageCard extends StatelessWidget {
  final ReimbursementModel reimbursement;
  final bool isOwnRequest;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onMarkPaid;

  const _ReimbursementManageCard({
    required this.reimbursement,
    required this.isOwnRequest,
    required this.onApprove,
    required this.onReject,
    required this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final statusColor = _getStatusColor(reimbursement.status);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  reimbursement.employeeName.isNotEmpty
                      ? reimbursement.employeeName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reimbursement.employeeName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${reimbursement.requesterRole.name.toUpperCase()} • ${reimbursement.typeText}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  reimbursement.statusText,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reimbursement.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(reimbursement.expenseDate),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      formatter.format(reimbursement.amount),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (reimbursement.status == ReimbursementStatus.pending &&
              isOwnRequest) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'You cannot approve your own request. Another Finance user must approve this.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (reimbursement.status == ReimbursementStatus.pending &&
              !isOwnRequest) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
          if (reimbursement.status == ReimbursementStatus.approved) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onMarkPaid,
                icon: const Icon(Icons.payment, size: 18),
                label: const Text('Mark as Paid'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(ReimbursementStatus status) {
    switch (status) {
      case ReimbursementStatus.pending:
        return Colors.orange;
      case ReimbursementStatus.approved:
        return Colors.green;
      case ReimbursementStatus.rejected:
        return Colors.red;
      case ReimbursementStatus.paid:
        return Colors.blue;
    }
  }
}
