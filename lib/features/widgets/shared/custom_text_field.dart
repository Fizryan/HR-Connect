import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String hint;
  final IconData icon;
  final ThemeData theme;
  final bool isPassword;
  final bool isLoading;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
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
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _isPasswordObscured : false,
          enabled: !widget.isLoading,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(color: widget.theme.colorScheme.onSurface, fontSize: 14.sp),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.theme.colorScheme.surfaceContainer,
            label: widget.title != null ? Text(widget.title!) : null,
            labelStyle: TextStyle(
              color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: (widget.readOnly
                  ? widget.theme.colorScheme.onSurface
                  : widget.theme.colorScheme.primary),
              size: 20.sp,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: widget.theme.colorScheme.onSurface,
                      size: 20.sp,
                    ),
                    onPressed: widget.isLoading
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
            focusedBorder: widget.readOnly
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: widget.theme.colorScheme.onSurface,
                      width: 1.5,
                    ),
                  ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
