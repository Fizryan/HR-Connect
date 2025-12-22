import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/settings/controllers/settings_controller.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;
  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullname);
    _nameController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final hasChanges = _nameController.text.trim() != widget.user.fullname;
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkChanges);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        widget.user.fullname.isNotEmpty
                            ? widget.user.fullname[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(
                      widget.user.role,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    widget.user.role.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(widget.user.role),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (v.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || !_hasChanges) ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: theme.colorScheme.onSurface
                        .withValues(alpha: 0.12),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: _hasChanges
                                ? Colors.white
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.38,
                                  ),
                          ),
                        ),
                ),
              ),
              if (!_hasChanges)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Center(
                    child: Text(
                      'Make changes to enable save',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.hrd:
        return Colors.orange;
      case UserRole.supervisor:
        return Colors.purple;
      case UserRole.finance:
        return Colors.teal;
      case UserRole.employee:
        return Colors.blue;
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: !_isLoading,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: theme.colorScheme.surface,
        errorMaxLines: 2,
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<SettingsController>().updateProfile(
        widget.user.uid,
        _nameController.text.trim(),
      );

      if (mounted) {
        await context.read<AuthController>().refreshUserData();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12.w),
                const Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage =
            context.read<SettingsController>().errorMessage ??
            'Failed to update profile';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12.w),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
