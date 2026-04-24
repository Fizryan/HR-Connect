import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = FlexThemeData.light(
    colors: AppColors.lightDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    scaffoldBackground: AppColors.lightPallet4,
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
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.darkPallet1,
      displayColor: AppColors.darkPallet1,
    ),
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    colors: AppColors.darkDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    scaffoldBackground: AppColors.darkPallet1,
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
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.lightPallet4,
      displayColor: AppColors.lightPallet4,
    ),
  );
}
