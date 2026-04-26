import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Dark Pallet
  static const Color darkPallet1 = Color.fromRGBO(46,52,64, 1);
  static const Color darkPallet2 = Color.fromRGBO(22,28,39, 1);
  static const Color darkPallet3 = Color.fromRGBO(43,49,60, 1);
  static const Color darkPallet4= Color.fromRGBO(65,71,83, 1);
  
  // Shade Pallet
  static const Color shadePallet1 = Color.fromRGBO(88,94,108, 1);
  static const Color shadePallet2 = Color.fromRGBO(113,119,133, 1);
  static const Color shadePallet3 = Color.fromRGBO(139,145,159, 1);
  
  // Light Pallet
  static const Color lightPallet1 = Color.fromRGBO(165,171,186, 1);
  static const Color lightPallet2 = Color.fromRGBO(193,198,214, 1);
  static const Color lightPallet3 = Color.fromRGBO(221,226,242, 1);
  static const Color lightPallet4 = Color.fromRGBO(236,240,255, 1);

  static const Color primary = Color.fromRGBO(136,192,208, 1);
  static const Color secondary = Color.fromRGBO(129,161,193, 1);
  static const Color tertiary = Color.fromRGBO(163,190,140, 1);
  static const Color neutral = Color.fromRGBO(46,52,64, 1);

  static const Color backgroundPrimary= Color.fromRGBO(22,28,39, 1);
  static const Color backgroundSecondary = Color.fromRGBO(236,240,255, 1);

  static const Color information = Color.fromRGBO(129,161,193, 1);
  static const Color error = Color.fromRGBO(161, 25, 25, 1);

  static const Color transparent = Colors.transparent;

  static const FlexSchemeColor lightDefault = FlexSchemeColor(
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    error: error,
  );

  static const FlexSchemeColor darkDefault = FlexSchemeColor(
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    error: error,
  );
}
