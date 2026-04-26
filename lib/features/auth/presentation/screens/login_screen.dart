import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/support_information.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  static final String _supportEmail = SupportInformation.supportEmail;
  static final String _supportPhone = SupportInformation.supportPhone;

  void _handleLogin(bool isLoading) async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading) return;

    final authProvider = context.read<AuthProvider>();

    await authProvider.login(_emailController.text, _passwordController.text);

    if (!mounted) return;

    final state = authProvider.value;
    state.maybeWhen(
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12.w),
                Expanded(child: Text(message)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      },
      orElse: () {},
    );
  }

  void _showForgotPasswordDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lock_reset,
              color: theme.colorScheme.primary,
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: theme.colorScheme.primary),
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
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.support_agent,
              color: theme.colorScheme.primary,
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
    final authState = context.watch<AuthProvider>().value;
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
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
                    SizedBox(height: 40.h),
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Email Address', theme),
                            SizedBox(height: 8.h),
                            _buildInput(
                              controller: _emailController,
                              hint: 'name@hrconnect.com',
                              icon: Icons.email_outlined,
                              theme: theme,
                              isLoading: isLoading,
                              isEmail: true,
                            ),
                            SizedBox(height: 20.h),
                            _buildLabel('Password', theme),
                            SizedBox(height: 8.h),
                            _buildInput(
                              controller: _passwordController,
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              isLoading: isLoading,
                              theme: theme,
                            ),
                            SizedBox(height: 12.h),
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
                            SizedBox(height: 32.h),
                            _buildLoginButton(theme, isLoading),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14.sp,
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
                              fontSize: 14.sp,
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
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.people_alt_rounded,
            size: 40.sp,
            color: theme.colorScheme.surface,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in to access your HR Connect',
          style: TextStyle(
            fontSize: 16.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
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
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
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
      onFieldSubmitted: isPassword ? (_) => _handleLogin(isLoading) : null,
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
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleLogin(isLoading),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.onPrimary.withValues(
            alpha: 0.5,
          ),
          disabledForegroundColor: theme.colorScheme.primary.withValues(
            alpha: 0.7,
          ),
          elevation: isLoading ? 0 : 2,
          shadowColor: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
