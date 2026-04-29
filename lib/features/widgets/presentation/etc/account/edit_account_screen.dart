import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/di/injection.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/logic/auth/providers/auth_state.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/providers/account_provider.dart';
import 'package:hr_connect/features/logic/account/providers/account_state.dart';
import 'package:hr_connect/features/widgets/presentation/shared/custom_text_field.dart';

class AdminEditAccountScreen extends StatefulWidget {
  final ColorScheme colorScheme;
  final AccountModel account;
  final AccountProvider accountProvider;

  const AdminEditAccountScreen({
    super.key,
    required this.colorScheme,
    required this.account,
    required this.accountProvider,
  });

  @override
  State<AdminEditAccountScreen> createState() => _AdminEditAccountScreenState();
}

class _AdminEditAccountScreenState extends State<AdminEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final uid = widget.account.uid;

  bool _isLoading = false;

  bool _isCurrentUser() {
    final authProvider = sl<AuthProvider>();
    final currentUser = authProvider.value.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    return currentUser?.uid == widget.account.uid;
  }

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.account.email);
    _passwordCtrl = TextEditingController(text: widget.account.password);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedAccount = widget.account.copyWith(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    await widget.accountProvider.updateAccount(updatedAccount);

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.accountProvider.value.maybeWhen(
      success: (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        widget.accountProvider.fetchAllAccounts();
        Navigator.pop(context);
      },
      error: (msg) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg))),
      orElse: () {},
    );
  }

  Future<void> _deleteAccount() async {
    if (_isCurrentUser()) return;

    final deleteFormKey = GlobalKey<FormState>();
    final expectedText = widget.account.email;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
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
                'Are you sure you want to delete this account? Please type the email below to confirm.',
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
                    v != expectedText ? 'Email does not match' : null,
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

    await widget.accountProvider.deleteAccount(widget.account.uid);

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.accountProvider.value.maybeWhen(
      success: (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        widget.accountProvider.fetchAllAccounts();
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
          'Edit Account',
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
                      icon: Icons.vpn_key_outlined,
                      theme: theme,
                      readOnly: true,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _emailCtrl,
                      title: 'Email Address',
                      hint: _emailCtrl.text,
                      icon: Icons.email_outlined,
                      theme: theme,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _passwordCtrl,
                      title: 'Password',
                      hint: 'Enter a new password',
                      icon: Icons.lock_outline,
                      theme: theme,
                      isPassword: true,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                          onPressed: _deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Delete Account',
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
