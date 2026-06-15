import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/validator.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_button.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_text_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _confirmSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    showCustomConfirmDialog(
      context: context,
      title: 'Change Password',
      description:
          'Are you sure you want to change your password? Your session will be ended.',
      confirmButtonText: 'Confirm',
      isDestructive: true,
      onConfirm: _savePassword,
    );
  }

  Future<void> _savePassword() async {
    setState(() {
      _isSaving = true;
    });

    final colorScheme = Theme.of(context).colorScheme;

    final result = await ref
        .read(authNotifierProvider.notifier)
        .changePassword(
          _newPasswordController.text,
          _oldPasswordController.text,
        );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    failure.message,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
            backgroundColor: colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(20.w),
            elevation: 0,
          ),
        );
      },
      (_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password changed successfully!'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(20.w),
          ),
        );

        await ref.read(authNotifierProvider.notifier).logout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Change Password',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: _oldPasswordController,
                  title: 'Old Password',
                  hint: '**********',
                  icon: Icons.lock_outline,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _newPasswordController,
                  title: 'New Password',
                  hint: '**********',
                  icon: Icons.lock_outline,
                  colorScheme: colorScheme,
                  isLoading: _isSaving,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _confirmSave(),
                  validator: Validator.requiredValidator,
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: 'Change Password',
                  isLoading: _isSaving,
                  onPressed: _confirmSave,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
