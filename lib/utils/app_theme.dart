import 'package:flutter/material.dart';

class PRFTheme {
  PRFTheme._();

  static const int primaryColor = 0xff17154c;
  static const int secondaryColor = 0xFF93D500;

  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(primaryColor),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: Color(primaryColor),
      secondary: Color(secondaryColor),
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(primaryColor),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(primaryColor),
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Color(primaryColor),
        disabledBackgroundColor: Color(primaryColor).withValues(alpha: .4),
        minimumSize: const Size(88, 56),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(primaryColor)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(primaryColor)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: Colors.black12,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(primaryColor),
    ),
  );
}
