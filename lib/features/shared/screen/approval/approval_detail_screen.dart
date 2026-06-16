import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/approval_policy.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/theme/status_color.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_snackbar.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

class ApprovalDetailScreen extends ConsumerStatefulWidget {
  final String requestId;
  final UserData requester;
  final RequestKind requestKind;
  final String type;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final UserData? approval;
  final String? reason;
  final RequestStatus status;

  const ApprovalDetailScreen({
    super.key,
    required this.requestId,
    required this.requester,
    required this.requestKind,
    required this.type,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.approval,
    this.reason,
  });

  @override
  ConsumerState<ApprovalDetailScreen> createState() =>
      _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends ConsumerState<ApprovalDetailScreen> {
  bool _isProcessing = false;

  void _showRejectReasonDialog() {
    final formKey = GlobalKey<FormState>();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Reject Request',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please provide a reason for rejecting this request:',
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'e.g., Urgent project coverage required',
                    hintStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.all(12.w),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Reason is required to reject';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final reason = reasonController.text.trim();
                  context.pop();
                  _confirmAction(false, reason);
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _confirmAction(bool isApprove, String reason) {
    final actionName = isApprove ? 'Approve' : 'Reject';
    final requestName = widget.requestKind == RequestKind.leave
        ? 'Leave'
        : 'Trip';

    showCustomConfirmDialog(
      context: context,
      title: '$actionName $requestName',
      description:
          'Are you sure you want to ${actionName.toLowerCase()} this request?',
      confirmButtonText: 'Yes, $actionName',
      isDestructive: !isApprove,
      onConfirm: () => _processRequest(isApprove, reason),
    );
  }

  Future<void> _processRequest(bool isApprove, String reason) async {
    setState(() => _isProcessing = true);

    try {
      Either<Failure, void> result;

      if (widget.requestKind == RequestKind.leave) {
        if (isApprove) {
          result = await ref
              .read(leaveNotifierProvider.notifier)
              .approveLeave(widget.requestId);
        } else {
          result = await ref
              .read(leaveNotifierProvider.notifier)
              .rejectLeave(widget.requestId, reason);
        }
      } else {
        if (isApprove) {
          result = await ref
              .read(tripNotifierProvider.notifier)
              .approveTrip(widget.requestId);
        } else {
          result = await ref
              .read(tripNotifierProvider.notifier)
              .rejectTrip(widget.requestId, reason);
        }
      }

      if (!mounted) return;

      result.fold(
        (failure) {
          CustomSnackBar.showError(context, message: failure.message);
        },
        (_) {
          CustomSnackBar.showSuccess(
            context,
            message: 'Request has been ${isApprove ? 'approved' : 'rejected'}.',
          );
          context.pop();
        },
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, message: e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenTitle = widget.requestKind == RequestKind.leave
        ? 'Leave Request'
        : 'Trip Request';

    final durationInDays =
        widget.endDate.difference(widget.startDate).inDays + 1;

    final currentUser = ref.read(authNotifierProvider).value;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          screenTitle,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: StatusColor.getStatusColor(
                  colorScheme,
                  widget.status,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: StatusColor.getStatusColor(
                    colorScheme,
                    widget.status,
                  ).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    StatusColor.getStatusIcon(widget.status),
                    color: StatusColor.getStatusColor(
                      colorScheme,
                      widget.status,
                    ),
                    size: 40.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    Capitalize.firstLetterUppercase(widget.status.name),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: StatusColor.getStatusColor(
                        colorScheme,
                        widget.status,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Request ID: ${widget.requestId}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'monospace',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Approver Information',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            if (widget.approval != null) ...[
              _buildInfoTile(
                context,
                icon: Icons.person,
                label: 'Processed By',
                value:
                    widget.approval!.firstName.isNotEmpty &&
                        widget.approval!.lastName.isNotEmpty
                    ? '${widget.approval!.firstName} ${widget.approval!.lastName}'
                    : 'N/A',
              ),
            ],
            if (widget.reason != null) ...[
              _buildInfoTile(
                context,
                icon: Icons.description_outlined,
                label: 'Rejected Reason',
                value: widget.reason!,
              ),
            ],
            Text(
              'Request Information',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInfoTile(
              context,
              icon: Icons.person_outline,
              label: 'Requester',
              value:
                  '${Capitalize.firstLetterUppercase(widget.requester.firstName)} ${Capitalize.firstLetterUppercase(widget.requester.lastName)}',
            ),
            _buildInfoTile(
              context,
              icon: Icons.admin_panel_settings_outlined,
              label: 'Role',
              value: Capitalize.firstLetterUppercase(
                widget.requester.role.name,
              ),
            ),
            _buildInfoTile(
              context,
              icon: Icons.category_outlined,
              label: 'Category Type',
              value: Capitalize.firstLetterUppercase(widget.type),
            ),
            _buildInfoTile(
              context,
              icon: Icons.description_outlined,
              label: 'Description',
              value: widget.description,
            ),
            SizedBox(height: 14.h),
            Text(
              'Schedule Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInfoTile(
              context,
              icon: Icons.calendar_today_rounded,
              label: 'Start Date',
              value:
                  '${widget.startDate.day}/${widget.startDate.month}/${widget.startDate.year}',
            ),
            _buildInfoTile(
              context,
              icon: Icons.event_rounded,
              label: 'End Date',
              value:
                  '${widget.endDate.day}/${widget.endDate.month}/${widget.endDate.year}',
            ),
            _buildInfoTile(
              context,
              icon: Icons.timer_outlined,
              label: 'Duration',
              value: '$durationInDays Day(s)',
              isLast: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          ApprovalPolicy.canApprove(widget.requester, currentUser!.data)
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: _isProcessing
                            ? null
                            : _showRejectReasonDialog,
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: _isProcessing
                            ? null
                            : () => _confirmAction(true, 'Approved'),
                        child: _isProcessing
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                'Approve',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 12.h),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            indent: 56.w,
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
