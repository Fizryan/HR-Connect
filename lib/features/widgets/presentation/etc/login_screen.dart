import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/support_information.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/auth/providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  static final String _supportEmail = SupportInformation.supportEmail;
  static final String _supportPhone = SupportInformation.supportPhone;

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    ref
        .read(authNotifierProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  void _showForgotPasswordDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lock_reset,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('Reset Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To reset your password, please contact the HR Administrator or IT Support:',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 16.h),
            _buildContactInfo(Icons.email, _supportEmail, theme),
            SizedBox(height: 8.h),
            _buildContactInfo(Icons.phone, _supportPhone, theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                theme.colorScheme.onTertiary,
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                theme.colorScheme.tertiary,
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.colorScheme.onSurface),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showContactInfo() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.support_agent,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('Contact Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please contact the HR Administrator or IT Support:',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 16.h),
            _buildContactInfo(Icons.email, _supportEmail, theme),
            SizedBox(height: 8.h),
            _buildContactInfo(Icons.phone, _supportPhone, theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                theme.colorScheme.onTertiary,
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                theme.colorScheme.tertiary,
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasLoading =
          previous?.maybeWhen(loading: () => true, orElse: () => false) ??
          false;

      if (wasLoading) {
        next.maybeWhen(
          unauthenticated: (message) {
            if (message != null && message.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: theme.colorScheme.errorContainer,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  margin: EdgeInsets.all(20.w),
                  elevation: 0,
                ),
              );
            }
          },
          orElse: () {},
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(theme),
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Email Address', theme),
                            SizedBox(height: 6.h),
                            _buildInput(
                              controller: _emailController,
                              hint: 'name@hrconnect.com',
                              icon: Icons.email_outlined,
                              theme: theme,
                              isLoading: isLoading,
                              isEmail: true,
                            ),
                            SizedBox(height: 16.h),
                            _buildLabel('Password', theme),
                            SizedBox(height: 6.h),
                            _buildInput(
                              controller: _passwordController,
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              isLoading: isLoading,
                              theme: theme,
                            ),
                            SizedBox(height: 10.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : _showForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            _buildLoginButton(theme, isLoading),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading ? null : _showContactInfo,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Contact Support',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.people_alt_rounded,
            size: 32.sp,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Sign in to access your HR Connect',
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required bool isLoading,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isPasswordObscured : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
      enabled: !isLoading,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface, size: 20.sp),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.colorScheme.onSurface,
                  size: 20.sp,
                ),
                onPressed: isLoading
                    ? null
                    : () => setState(
                        () => _isPasswordObscured = !_isPasswordObscured,
                      ),
              )
            : null,
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
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return isEmail ? 'Email is required' : 'Password is required';
        }
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onFieldSubmitted: isPassword && !isLoading ? (_) => _handleLogin() : null,
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: FilledButton(
        onPressed: isLoading ? null : _handleLogin,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 4.w,
                width: double.infinity,
                child: LinearProgressIndicator(
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              )
            : Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
