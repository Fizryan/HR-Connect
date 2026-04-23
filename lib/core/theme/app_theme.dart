import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final _baseTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  static final ThemeData lightTheme = FlexThemeData.light(
    colors: AppColors.lightDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    scaffoldBackground: AppColors.lightBackground,
    useMaterial3: true,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      cardElevation: 2.0,
      cardRadius: 16.0,
    ),
    textTheme: TextTheme(
      displayLarge: _baseTextStyle.copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold),
      bodyLarge: _baseTextStyle.copyWith(fontSize: 16.sp),
      bodyMedium: _baseTextStyle,
      titleMedium: _baseTextStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
    ).apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    colors: AppColors.darkDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    scaffoldBackground: AppColors.darkBackground,
    useMaterial3: true,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      cardElevation: 2.0,
      cardRadius: 16.0,
    ),
    textTheme: TextTheme(
      displayLarge: _baseTextStyle.copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold),
      bodyLarge: _baseTextStyle.copyWith(fontSize: 16.sp),
      bodyMedium: _baseTextStyle,
      titleMedium: _baseTextStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
    ).apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
  );
}
