import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const FlexSubThemesData _subThemesData = FlexSubThemesData(
    blendOnLevel: 10,
    defaultRadius: 12.0,
    cardRadius: 16.0,
    cardElevation: 2.0,
    blendOnColors: false,
    useMaterial3Typography: true,
    useM2StyleDividerInM3: true,
    inputDecoratorUnfocusedHasBorder: true,
  );

  static final ThemeData lightTheme = FlexThemeData.light(
    colors: AppColors.lightDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    useMaterial3: true,
    subThemesData: _subThemesData,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    colors: AppColors.darkDefault,
    surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
    blendLevel: 10,
    useMaterial3: true,
    subThemesData: _subThemesData,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
