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

  static const Color information = Color.fromRGBO(129,161,193, 1);
  static const Color error = Color.fromRGBO(129,12,12, 1);

  static const Color transparent = Colors.transparent;

  static const FlexSchemeColor lightDefault = FlexSchemeColor(
    primary: lightPallet4,
    secondary: lightPallet3,
    appBarColor: lightPallet2,
    error: error,
  );

  static const FlexSchemeColor darkDefault = FlexSchemeColor(
    primary: darkPallet1,
    secondary: darkPallet2,
    appBarColor: darkPallet3,
    error: error,
  );
}
