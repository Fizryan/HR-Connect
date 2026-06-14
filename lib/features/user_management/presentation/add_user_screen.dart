import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/config/validator.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:hr_connect/features/shared/widgets/custom_snackbar.dart';
import 'package:hr_connect/features/shared/widgets/custom_text_field.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Role? _selectedRole;
  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      CustomSnackBar.showError(
        context,
        message: 'Please select a role for the new user',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    final newUserData = UserData(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      role: _selectedRole!,
      avatarUrl: null,
    );

    final result = await ref
        .read(userNotifierProvider.notifier)
        .registerUser(newUserData, _passwordController.text.trim());

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        CustomSnackBar.showError(context, message: failure.message);
      },
      (_) async {
        CustomSnackBar.showSuccess(
          context,
          message: 'User added successfully!',
        );
        ref.read(userNotifierProvider.notifier).refreshUsers();
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Add New User',
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
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _firstNameController,
                  title: 'First Name',
                  hint: 'Enter first name',
                  icon: Icons.person_outline_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _lastNameController,
                  title: 'Last Name',
                  hint: 'Enter last name',
                  icon: Icons.person_outline_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Account Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _emailController,
                  title: 'Email Address',
                  hint: 'Enter email address',
                  icon: Icons.email_outlined,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validator.emailValidator,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _passwordController,
                  title: 'Initial Password',
                  hint: 'Enter initial password',
                  icon: Icons.lock_outline_rounded,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Role',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<Role>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        hintText: 'Select a role',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        prefixIcon: Icon(
                          Icons.admin_panel_settings_outlined,
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
                      items: Role.values.where((r) => r != Role.unknown).map((
                        role,
                      ) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(
                            Capitalize.firstLetterUppercase(role.name),
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
                                _selectedRole = value;
                              });
                            },
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Create User',
                  isLoading: _isSaving,
                  onPressed: _addUser,
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
