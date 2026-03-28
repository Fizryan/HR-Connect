import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final _baseTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _baseTextStyle.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold
      ),
    ),
    textTheme: TextTheme(
      displayLarge: _baseTextStyle.copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold),
      bodyLarge: _baseTextStyle.copyWith(fontSize: 16.sp),
      bodyMedium: _baseTextStyle,
      titleMedium: _baseTextStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)
    )
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _baseTextStyle.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary
      ),
    ),
    textTheme: TextTheme(
      displayLarge: _baseTextStyle.copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
      bodyLarge: _baseTextStyle.copyWith(fontSize: 16.sp, color: AppColors.darkTextPrimary),
      bodyMedium: _baseTextStyle.copyWith(color: AppColors.darkTextPrimary),
      titleMedium: _baseTextStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
    )
  );
}