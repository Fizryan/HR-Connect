import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBackground = Color.fromRGBO(216, 222, 233, 1);
  static const Color lightAccent = Color.fromRGBO(229,233,240, 1);
  static const Color lightSurface = Color.fromRGBO(216, 222, 233, 1);
  
  static const Color darkBackground = Color.fromRGBO(46, 52, 64, 1);
  static const Color darkAccent = Color.fromRGBO(59,66,82, 1);  
  static const Color darkSurface = Color.fromRGBO(46, 52, 64, 1);

  static const Color textLight = Color.fromRGBO(236, 239, 244, 1);
  static const Color textDark = Color.fromRGBO(76, 86, 106, 1);

  static const Color information = Color.fromRGBO(94,129,172, 1);
  static const Color error = Color.fromRGBO(191,97,106, 1);

  static const Color transparent = Colors.transparent;

  static const FlexSchemeColor lightDefault = FlexSchemeColor(
    primary: darkBackground,
    secondary: darkSurface,
    appBarColor: darkAccent,
    error: error,
  );

  static const FlexSchemeColor darkDefault = FlexSchemeColor(
    primary: lightBackground,
    secondary: lightSurface,
    appBarColor: lightAccent,
    error: error,
  );
}
