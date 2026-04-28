import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_state.dart';

class AdminCreateUserScreen extends StatefulWidget {
  final ColorScheme colorScheme;
  final UserProvider userProvider;

  const AdminCreateUserScreen({
    super.key,
    required this.colorScheme,
    required this.userProvider,
  });

  @override
  State<AdminCreateUserScreen> createState() => _AdminCreateUserScreenState();
}

class _AdminCreateUserScreenState extends State<AdminCreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();

  late UserRole _selectedRole = UserRole.values.first;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newUser = UserModel(
      uid: '',
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await widget.userProvider.createUser(newUser);
    } catch (e) {
      debugPrint('Error creating user: $e');
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.userProvider.value.maybeWhen(
      success: (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        widget.userProvider.fetchAllUsers();
        Navigator.pop(context);
      },
      error: (msg) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg))),
      orElse: () {
        widget.userProvider.fetchAllUsers();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create User',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInput(
                      controller: _firstNameCtrl,
                      hint: 'First Name',
                      icon: Icons.person_outline,
                      theme: theme,
                    ),
                    SizedBox(height: 16.h),
                    _buildInput(
                      controller: _lastNameCtrl,
                      hint: 'Last Name',
                      icon: Icons.person_outline,
                      theme: theme,
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<UserRole>(
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: UserRole.values
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedRole = v);
                      },
                    ),
                    SizedBox(height: 16.h),
                    SwitchListTile(
                      title: const Text('Active Status'),
                      contentPadding: EdgeInsets.zero,
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Create User',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colorScheme.onPrimary,
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

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ThemeData theme,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface, size: 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}
