import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/config/validator.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:hr_connect/features/shared/widgets/custom_snackbar.dart';
import 'package:hr_connect/features/shared/widgets/custom_text_field.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';

class AddRequestScreen extends ConsumerStatefulWidget {
  const AddRequestScreen({super.key});

  @override
  ConsumerState<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends ConsumerState<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  RequestKind _selectedKind = RequestKind.leave;
  String? _selectedCategory;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: Theme.of(context).colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedCategory == null) {
      CustomSnackBar.showError(context, message: 'Please select a category.');
      return;
    }
    if (_startDate == null || _endDate == null) {
      CustomSnackBar.showError(
        context,
        message: 'Please select start and end dates.',
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      CustomSnackBar.showError(
        context,
        message: 'End date cannot be earlier than start date.',
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      if (_selectedKind == RequestKind.leave) {
        final data = LeaveData(
          type: _selectedCategory!,
          description: _descriptionController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
        );
        await ref.read(leaveMeNotifierProvider.notifier).createLeave(data);
      } else {
        final data = TripData(
          type: _selectedCategory!,
          description: _descriptionController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
        );
        await ref.read(tripMeNotifierProvider.notifier).createTrip(data);
      }

      if (!mounted) return;
      CustomSnackBar.showSuccess(
        context,
        message: 'Request submitted successfully!',
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, message: e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentCategories = _selectedKind == RequestKind.leave
        ? LeaveType.values
        : TripType.values;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Create Request',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Type',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<RequestKind>(
                    segments: const [
                      ButtonSegment<RequestKind>(
                        value: RequestKind.leave,
                        label: Text('Leave'),
                        icon: Icon(Icons.beach_access_rounded),
                      ),
                      ButtonSegment<RequestKind>(
                        value: RequestKind.trip,
                        label: Text('Trip'),
                        icon: Icon(Icons.flight_takeoff_rounded),
                      ),
                    ],
                    selected: {_selectedKind},
                    onSelectionChanged: _isSaving
                        ? null
                        : (Set<RequestKind> newSelection) {
                            setState(() {
                              _selectedKind = newSelection.first;
                              _selectedCategory = null;
                            });
                          },
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: colorScheme.primaryContainer,
                      selectedForegroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_selectedKind),
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        hintText: 'Select category',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        prefixIcon: Icon(
                          Icons.category_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      dropdownColor: colorScheme.surfaceContainer,
                      items: currentCategories.map((enumItem) {
                        return DropdownMenuItem<String>(
                          value: enumItem.name,
                          child: Text(
                            Capitalize.firstLetterUppercase(enumItem.name),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _descriptionController,
                  title: 'Description',
                  hint: 'Explain your request briefly',
                  icon: Icons.description_outlined,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  textInputAction: TextInputAction.done,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 32.h),

                Text(
                  'Schedule Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: _isSaving ? null : () => _selectDate(context, true),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: _startDate != null
                            ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                            : '',
                      ),
                      title: 'Start Date',
                      hint: 'Select start date',
                      icon: Icons.calendar_today_rounded,
                      colorScheme: colorScheme,
                      isLoading: _isSaving,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: _isSaving ? null : () => _selectDate(context, false),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: _endDate != null
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : '',
                      ),
                      title: 'End Date',
                      hint: 'Select end date',
                      icon: Icons.event_rounded,
                      colorScheme: colorScheme,
                      isLoading: _isSaving,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Submit Request',
                  isLoading: _isSaving,
                  onPressed: _submitRequest,
                  colorScheme: colorScheme,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
