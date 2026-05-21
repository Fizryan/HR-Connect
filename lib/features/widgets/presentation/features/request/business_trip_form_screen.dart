import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/business_trip/provider/business_provider.dart';
import 'package:hr_connect/features/widgets/shared/custom_text_field.dart';
import 'package:intl/intl.dart';

class BusinessTripFormScreen extends ConsumerStatefulWidget {
  final String? existingRequestId;
  final BusinessTripType? initialType;
  final String? initialDescription;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const BusinessTripFormScreen({
    super.key,
    this.existingRequestId,
    this.initialType,
    this.initialDescription,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  ConsumerState<BusinessTripFormScreen> createState() => _BusinessTripFormScreenState();
}

class _BusinessTripFormScreenState extends ConsumerState<BusinessTripFormScreen> {
  late TextEditingController _descController;
  BusinessTripType? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _descController = TextEditingController(text: widget.initialDescription);
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_selectedType == null || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all required fields.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final requestData = {
        'type': _selectedType!.name,
        'description': _descController.text,
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
      };

      if (widget.existingRequestId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update functionality requires backend integration.')),
        );
      } else {
        await ref.read(businessNotifierProvider.notifier).createBusinessTrip(requestData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Business trip request created successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUpdate = widget.existingRequestId != null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        title: Text(
          isUpdate ? 'Edit Business Trip' : 'New Business Trip',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Type',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<BusinessTripType>(
              initialValue: _selectedType,
              hint: Text(
                'Select trip type',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 14.sp,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: colorScheme.primary, width: 1.5.w),
                ),
              ),
              dropdownColor: colorScheme.surfaceContainer,
              items: BusinessTripType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    Capitalize.firstLetterUppercase(type.name),
                    style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            SizedBox(height: 20.h),
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _pickDateRange,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range_rounded, color: colorScheme.onSurfaceVariant),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        (_startDate != null && _endDate != null)
                            ? '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}'
                            : 'Select start and end date',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: (_startDate != null)
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: _descController,
              title: 'Description',
              hint: 'Destination and purpose...',
              icon: Icons.business_center_rounded,
              theme: Theme.of(context),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: FilledButton(
                onPressed: _isLoading ? null : _submitForm,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24.w,
                        width: 24.w,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        isUpdate ? 'Save Changes' : 'Submit Request',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
