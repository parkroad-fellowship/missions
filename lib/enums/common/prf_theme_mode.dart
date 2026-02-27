import 'package:flutter/material.dart';

/// Theme mode options for the app.
enum PRFThemeMode {
  system,
  light,
  dark
  ;

  /// Convert to Flutter's ThemeMode.
  ThemeMode toFlutterThemeMode() {
    return switch (this) {
      PRFThemeMode.system => ThemeMode.system,
      PRFThemeMode.light => ThemeMode.light,
      PRFThemeMode.dark => ThemeMode.dark,
    };
  }

  /// Create from Flutter's ThemeMode.
  static PRFThemeMode fromFlutterThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => PRFThemeMode.system,
      ThemeMode.light => PRFThemeMode.light,
      ThemeMode.dark => PRFThemeMode.dark,
    };
  }

  /// Parse from string value (for storage).
  static PRFThemeMode fromString(String value) {
    return switch (value) {
      'light' => PRFThemeMode.light,
      'dark' => PRFThemeMode.dark,
      _ => PRFThemeMode.system,
    };
  }
}
