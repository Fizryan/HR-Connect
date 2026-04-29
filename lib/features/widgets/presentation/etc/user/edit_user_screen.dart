import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_state.dart';
import 'package:hr_connect/features/logic/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_state.dart';
import 'package:hr_connect/features/widgets/presentation/shared/custom_text_field.dart';

class AdminEditUserScreen extends StatefulWidget {
  final ColorScheme colorScheme;
  final UserModel user;
  final UserProvider userProvider;

  const AdminEditUserScreen({
    super.key,
    required this.colorScheme,
    required this.user,
    required this.userProvider,
  });

  @override
  State<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends State<AdminEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final uid = widget.user.uid;
  late final createdAt = widget.user.createdAt;
  late final updatedAt = widget.user.updatedAt;
  late UserRole _selectedRole;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user.firstName);
    _lastNameCtrl = TextEditingController(text: widget.user.lastName);
    _selectedRole = widget.user.role;
    _isActive = widget.user.isActive;
  }

  bool _isCurrentUser() {
    final authProvider = sl<AuthProvider>();
    final currentUser = authProvider.value.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    return currentUser?.uid == widget.user.uid;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedUser = widget.user.copyWith(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
      updatedAt: DateTime.now(),
    );

    await widget.userProvider.updateUser(updatedUser);

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
      orElse: () {},
    );
  }

  Future<void> _deleteUser() async {
    if (_isCurrentUser()) return;

    final deleteFormKey = GlobalKey<FormState>();
    final expectedText = '${widget.user.firstName} ${widget.user.lastName}';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete User',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Form(
          key: deleteFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this user? Please type the name below to confirm.',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                expectedText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLowest,
                  hintText: 'Fill the text to confirm',
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 14.sp,
                  ),
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
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                ),
                validator: (v) =>
                    v != expectedText ? 'Text does not match' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (deleteFormKey.currentState?.validate() ?? false) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    await widget.userProvider.deleteUser(widget.user.uid);

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
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User',
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
                    CustomTextField(
                      title: 'UID',
                      hint: uid.toString(),
                      icon: Icons.person_outline,
                      theme: theme,
                      readOnly: true,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _firstNameCtrl,
                      title: 'First Name',
                      hint: _firstNameCtrl.text,
                      icon: Icons.short_text_outlined,
                      theme: theme,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _lastNameCtrl,
                      title: 'Last Name',
                      hint: _lastNameCtrl.text,
                      icon: Icons.short_text_outlined,
                      theme: theme,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<UserRole>(
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: UserRole.values
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              enabled:
                                  !_isCurrentUser() || role == _selectedRole,
                              child: Text(role.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: _isCurrentUser()
                          ? null
                          : (v) {
                              if (v != null) setState(() => _selectedRole = v);
                            },
                    ),
                    SizedBox(height: 16.h),
                    SwitchListTile(
                      title: const Text('Active Status'),
                      subtitle: _isCurrentUser()
                          ? const Text(
                              'You cannot change your own status',
                              style: TextStyle(fontSize: 12),
                            )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      value: _isActive,
                      onChanged: _isCurrentUser()
                          ? null
                          : (v) => setState(() => _isActive = v),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      title: 'Created At',
                      hint: createdAt.toString(),
                      icon: Icons.date_range_outlined,
                      theme: theme,
                      readOnly: true,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      title: 'Updated At',
                      hint: updatedAt.toString(),
                      icon: Icons.date_range_outlined,
                      theme: theme,
                      readOnly: true,
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
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (!_isCurrentUser()) ...[
                      SizedBox(height: 22.h),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _deleteUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Delete User',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colorScheme.onError,
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
}
