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
}
