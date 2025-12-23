import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/user_management/controllers/user_management_controller.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddEditUserView extends StatefulWidget {
  final UserModel? user;
  final bool isHrdMode;

  const AddEditUserView({super.key, this.user, this.isHrdMode = false});

  @override
  State<AddEditUserView> createState() => _AddEditUserViewState();
}

class _AddEditUserViewState extends State<AddEditUserView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _roleController;
  String _status = 'active';
  UserRole _selectedRole = UserRole.employee;
  bool _obscurePassword = true;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullname ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _roleController = TextEditingController(
      text: widget.user?.role.name ?? 'employee',
    );
    _status = widget.user?.status.toLowerCase() ?? 'active';
    _selectedRole = widget.user?.role ?? UserRole.employee;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Add User'),
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
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                validator: (v) => v!.isEmpty ? 'Required' : null,
                enabled: !isEditing,
              ),
              SizedBox(height: 16.h),
              if (!isEditing)
                Column(
                  children: [
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      validator: (v) {
                        if (v!.isEmpty) return 'Required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              _buildRoleDropdown(),
              SizedBox(height: 16.h),
              _buildStatusDropdown(),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isSaving || _isDeleting) ? null : _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor: theme.colorScheme.primary
                        .withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? 'Update User' : 'Create User',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
              if (isEditing && !widget.isHrdMode) ...[
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: (_isSaving || _isDeleting) ? null : _deleteUser,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                        color: (_isSaving || _isDeleting)
                            ? theme.colorScheme.error.withValues(alpha: 0.3)
                            : theme.colorScheme.error,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isDeleting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.error,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Delete User',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool enabled = true,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      obscureText: obscureText,
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
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    final theme = Theme.of(context);
    return DropdownButtonFormField2<UserRole>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: 'Role',
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        prefixIcon: Icon(
          Icons.badge_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: EdgeInsets.zero,
      ),
      isExpanded: true,
      hint: Text(
        'Select Role',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: theme.colorScheme.surface,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
      buttonStyleData: ButtonStyleData(
        height: 56.h,
        padding: EdgeInsets.only(left: 0, right: 10.w),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24.sp,
        iconEnabledColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      items: UserRole.values.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Text(role.name.toUpperCase()),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _selectedRole = val);
      },
    );
  }

  Widget _buildStatusDropdown() {
    final theme = Theme.of(context);
    return DropdownButtonFormField2<String>(
      value: _status,
      decoration: InputDecoration(
        labelText: 'Status',
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        prefixIcon: Icon(
          Icons.info_outline,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: EdgeInsets.zero,
      ),
      isExpanded: true,
      hint: Text(
        'Select Status',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: theme.colorScheme.surface,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
      buttonStyleData: ButtonStyleData(
        height: 56.h,
        padding: EdgeInsets.only(left: 0, right: 10.w),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24.sp,
        iconEnabledColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      items: ['active', 'inactive'].map((s) {
        return DropdownMenuItem<String>(value: s, child: Text(s.toUpperCase()));
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _status = val);
      },
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('email-already-in-use')) {
      return 'Email already registered';
    } else if (error.toString().contains('invalid-email')) {
      return 'Invalid email format';
    } else if (error.toString().contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.toString().contains('wrong-password')) {
      return 'Incorrect admin password';
    } else if (error.toString().contains('permission-denied')) {
      return 'Permission denied. Check your admin credentials.';
    }
    return 'Error: ${error.toString().split(']').last.trim()}';
  }

  Future<String?> _showAdminPasswordDialog(ThemeData theme) async {
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.security,
                color: theme.colorScheme.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Confirm Identity',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your password to create a new user:',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Your Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setDialogState(() => obscurePassword = !obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, null),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text.isEmpty) return;
                Navigator.pop(dialogContext, passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    final isCreating = widget.user == null;
    final controller = context.read<UserManagementController>();
    final authController = context.read<AuthController>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    String? adminPassword;
    if (isCreating) {
      adminPassword = await _showAdminPasswordDialog(theme);
      if (adminPassword == null) return;
    }

    setState(() => _isSaving = true);

    try {
      if (!isCreating) {
        final updatedUser = widget.user!.copyWith(
          fullname: _nameController.text.trim(),
          role: _selectedRole,
          isActive: _status == 'active',
        );
        await controller.updateUser(updatedUser);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12.w),
                  const Text('User updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          navigator.pop();
        }
      } else {
        final newUser = UserModel(
          uid: '',
          email: _emailController.text.trim(),
          fullname: _nameController.text.trim(),
          role: _selectedRole,
          isActive: _status == 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await controller.addUser(
          newUser,
          _passwordController.text,
          authController.user!.email,
          adminPassword!,
        );
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12.w),
                  const Text('User created successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          navigator.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = _getErrorMessage(e);
        scaffoldMessenger.showSnackBar(
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
        setState(() => _isSaving = false);
      }
    }
  }

  void _deleteUser() async {
    final currentUser = context.read<AuthController>().user;
    if (currentUser != null && currentUser.uid == widget.user!.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12.w),
              const Text('You cannot delete your own account'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: theme.colorScheme.error, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              'Delete User',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${widget.user!.fullname}"?',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isDeleting = true);

      try {
        final controller = context.read<UserManagementController>();
        await controller.deleteUser(widget.user!.uid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12.w),
                  const Text('User deleted successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isDeleting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(child: Text('Error: ${e.toString()}')),
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
      }
    }
  }
}
