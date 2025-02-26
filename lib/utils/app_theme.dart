import 'package:flutter/material.dart';

class PRFTheme {
  PRFTheme._();

  static const int primaryColor = 0xff17154c;
  static const int secondaryColor = 0xFF93D500;

  static final light = ThemeData(
    primaryColor: const Color(primaryColor), // Dark Blue
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: Color(primaryColor),
      secondary: Color(secondaryColor), // Green
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );
}
