import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/providers/account_provider.dart';
import 'package:hr_connect/features/logic/account/providers/account_state.dart';

class AdminCreateAccountScreen extends StatefulWidget {
  final ColorScheme colorScheme;
  final AccountProvider accountProvider;

  const AdminCreateAccountScreen({
    super.key,
    required this.colorScheme,
    required this.accountProvider,
  });

  @override
  State<AdminCreateAccountScreen> createState() => _AdminCreateAccountScreenState();
}

class _AdminCreateAccountScreenState extends State<AdminCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newAccount = AccountModel(
      uid: '', // Biasanya dibuat di backend
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    try {
      await widget.accountProvider.createAccount(newAccount);
    } catch (e) {
      debugPrint('Error creating account: $e');
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.accountProvider.value.maybeWhen(
      success: (msg) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        widget.accountProvider.fetchAllAccounts();
        Navigator.pop(context);
      },
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
      orElse: () {
        widget.accountProvider.fetchAllAccounts();
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
          'Create Account',
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
                      controller: _emailCtrl,
                      hint: 'Email Address',
                      icon: Icons.email_outlined,
                      theme: theme,
                    ),
                    SizedBox(height: 16.h),
                    _buildInput(
                      controller: _passwordCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      theme: theme,
                      isPassword: true,
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
                          'Create Account',
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
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14.sp),
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface, size: 20.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: theme.colorScheme.onSurface, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5)),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}