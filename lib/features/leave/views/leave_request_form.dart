import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hr_connect/features/leave/controllers/leave_controller.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';

class LeaveRequestForm extends StatefulWidget {
  final LeaveModel? existingLeave;

  const LeaveRequestForm({super.key, this.existingLeave});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  late LeaveType _selectedType;
  late DateTime _startDate;
  late DateTime _endDate;
  late TextEditingController _reasonController;
  bool _isSubmitting = false;

  bool get isEditing => widget.existingLeave != null;
  int get totalDays => _endDate.difference(_startDate).inDays + 1;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.existingLeave?.type ?? LeaveType.annual;
    _startDate =
        widget.existingLeave?.startDate ??
        DateTime.now().add(const Duration(days: 1));
    _endDate =
        widget.existingLeave?.endDate ??
        DateTime.now().add(const Duration(days: 1));
    _reasonController = TextEditingController(
      text: widget.existingLeave?.reason ?? '',
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(theme),
                SizedBox(height: 16.h),
                _buildTitle(theme),
                SizedBox(height: 24.h),
                _buildLeaveTypeField(theme),
                SizedBox(height: 16.h),
                _buildDateRange(theme),
                SizedBox(height: 8.h),
                _buildTotalDays(theme),
                SizedBox(height: 16.h),
                _buildReasonField(theme),
                SizedBox(height: 24.h),
                _buildSubmitButton(theme),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      isEditing ? 'Edit Leave Request' : 'New Leave Request',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildLeaveTypeField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Leave Type', theme),
        SizedBox(height: 8.h),
        DropdownButtonFormField2<LeaveType>(
          value: _selectedType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          items: LeaveType.values.map((type) {
            return DropdownMenuItem<LeaveType>(
              value: type,
              child: Text(_getTypeText(type)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedType = value);
          },
        ),
      ],
    );
  }

  Widget _buildDateRange(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildDateField('Start Date', _startDate, true, theme)),
        SizedBox(width: 16.w),
        Expanded(child: _buildDateField('End Date', _endDate, false, theme)),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    bool isStart,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, theme),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _selectDate(context, isStart),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 8.w),
                Text(
                  DateFormat('MMM d, yyyy').format(date),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalDays(ThemeData theme) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Total: $totalDays days',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildReasonField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Reason', theme),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _reasonController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter reason for leave...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter a reason'
              : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: _isSubmitting
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text(
                isEditing ? 'Update Request' : 'Submit Request',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  String _getTypeText(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.personal:
        return 'Personal Leave';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.unpaid:
        return 'Unpaid Leave';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final firstDate = isStart ? DateTime.now() : _startDate;
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) _endDate = _startDate;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final auth = context.read<AuthController>();
      final controller = context.read<LeaveController>();
      final user = auth.user!;

      if (isEditing) {
        await controller.updateLeave(
          widget.existingLeave!.id,
          type: _selectedType,
          startDate: _startDate,
          endDate: _endDate,
          reason: _reasonController.text.trim(),
        );
      } else {
        await controller.submitLeaveRequest(
          uid: user.uid,
          employeeName: user.fullname,
          requesterRole: user.role,
          type: _selectedType,
          startDate: _startDate,
          endDate: _endDate,
          reason: _reasonController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Leave request updated' : 'Leave request submitted',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
