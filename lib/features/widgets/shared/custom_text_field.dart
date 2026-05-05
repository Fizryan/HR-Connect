import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String hint;
  final IconData icon;
  final ThemeData theme;
  final bool isPassword;
  final bool isLoading;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.title,
    required this.hint,
    required this.icon,
    required this.theme,
    this.isPassword = false,
    this.isLoading = false,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          enabled: !isLoading,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer,
            label: Text(title ?? ''),
            labelStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              icon,
              color: (readOnly
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.primary),
              size: 20.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: readOnly
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface,
                      width: 1.5,
                    ),
                  ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
