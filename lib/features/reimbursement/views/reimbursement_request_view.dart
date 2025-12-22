import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:hr_connect/features/reimbursement/controllers/reimbursement_controller.dart';
import 'package:hr_connect/features/reimbursement/models/reimbursement_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReimbursementRequestView extends StatefulWidget {
  const ReimbursementRequestView({super.key});

  @override
  State<ReimbursementRequestView> createState() =>
      _ReimbursementRequestViewState();
}

class _ReimbursementRequestViewState extends State<ReimbursementRequestView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().user?.uid;
      if (userId != null) {
        context.read<ReimbursementController>().fetchMyReimbursements(userId);
      }
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
            return RefreshIndicator(
              onRefresh: () async {
                final userId = context.read<AuthController>().user?.uid;
                if (userId != null) {
                  await controller.fetchMyReimbursements(userId);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      title: 'Reimbursement',
                      subtitle: 'Submit and track expense claims',
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryCards(context, controller),
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
        onPressed: () => _showReimbursementForm(context),
        icon: const Icon(Icons.add),
        label: const Text('New Claim'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    ReimbursementController controller,
  ) {
    final myReimbursements = controller.myReimbursements;
    final pending = myReimbursements.where(
      (r) => r.status == ReimbursementStatus.pending,
    );
    final approved = myReimbursements.where(
      (r) => r.status == ReimbursementStatus.approved,
    );
    final paid = myReimbursements.where(
      (r) => r.status == ReimbursementStatus.paid,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Pending',
              count: pending.length,
              amount: pending.fold(0.0, (sum, r) => sum + r.amount),
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _SummaryCard(
              title: 'Approved',
              count: approved.length,
              amount: approved.fold(0.0, (sum, r) => sum + r.amount),
              color: Colors.green,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _SummaryCard(
              title: 'Paid',
              count: paid.length,
              amount: paid.fold(0.0, (sum, r) => sum + r.amount),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequests(
    BuildContext context,
    ThemeData theme,
    ReimbursementController controller,
  ) {
    if (controller.isLoading && controller.myReimbursements.isEmpty) {
      return const LoadingState(message: 'Loading requests...');
    }

    if (controller.myReimbursements.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
        child: const EmptyState(
          icon: Icons.receipt_long,
          title: 'No reimbursement requests',
          subtitle: 'Tap + to submit your first expense claim',
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Requests',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          ...controller.myReimbursements.map(
            (r) => _ReimbursementCard(reimbursement: r),
          ),
        ],
      ),
    );
  }

  void _showReimbursementForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ReimbursementFormSheet(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final double amount;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            formatter.format(amount),
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

class _ReimbursementCard extends StatelessWidget {
  final ReimbursementModel reimbursement;

  const _ReimbursementCard({required this.reimbursement});

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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _getTypeIcon(reimbursement.type),
                  color: theme.colorScheme.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reimbursement.typeText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(reimbursement.expenseDate),
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
                'Amount',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                formatter.format(reimbursement.amount),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (reimbursement.rejectionReason != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      reimbursement.rejectionReason!,
                      style: TextStyle(fontSize: 11.sp, color: Colors.red),
                    ),
                  ),
                ],
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

  IconData _getTypeIcon(ReimbursementType type) {
    switch (type) {
      case ReimbursementType.transportation:
        return Icons.directions_car;
      case ReimbursementType.meals:
        return Icons.restaurant;
      case ReimbursementType.accommodation:
        return Icons.hotel;
      case ReimbursementType.officeSupplies:
        return Icons.inventory_2;
      case ReimbursementType.medical:
        return Icons.medical_services;
      case ReimbursementType.training:
        return Icons.school;
      case ReimbursementType.other:
        return Icons.receipt;
    }
  }
}

class _ReimbursementFormSheet extends StatefulWidget {
  const _ReimbursementFormSheet();

  @override
  State<_ReimbursementFormSheet> createState() =>
      _ReimbursementFormSheetState();
}

class _ReimbursementFormSheetState extends State<_ReimbursementFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReimbursementType _selectedType = ReimbursementType.transportation;
  DateTime _expenseDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final authController = context.read<AuthController>();
    final reimbursementController = context.read<ReimbursementController>();
    final user = authController.user;

    if (user == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final success = await reimbursementController.submitReimbursement(
      uid: user.uid,
      employeeName: user.fullname,
      requesterRole: user.role,
      type: _selectedType,
      amount: double.parse(
        _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      ),
      description: _descriptionController.text,
      expenseDate: _expenseDate,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reimbursement submitted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reimbursementController.errorMessage ?? 'Failed to submit',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'New Expense Claim',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Expense Type',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<ReimbursementType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                items: ReimbursementType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getTypeText(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedType = value);
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Amount (Rp)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = int.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'Expense Date',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expenseDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 90),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _expenseDate = date);
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20.sp),
                      SizedBox(width: 12.w),
                      Text(DateFormat('dd MMM yyyy').format(_expenseDate)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe the expense...',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Submit Claim'),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeText(ReimbursementType type) {
    switch (type) {
      case ReimbursementType.transportation:
        return 'Transportation';
      case ReimbursementType.meals:
        return 'Meals & Entertainment';
      case ReimbursementType.accommodation:
        return 'Accommodation';
      case ReimbursementType.officeSupplies:
        return 'Office Supplies';
      case ReimbursementType.medical:
        return 'Medical Expenses';
      case ReimbursementType.training:
        return 'Training & Education';
      case ReimbursementType.other:
        return 'Other';
    }
  }
}
