import 'dart:ui';

import 'package:prf_design/prf_design.dart';

/// Custom brand configuration for HMT Missions.
///
/// Palette:
///   Deep Forest #1F4228  → primary
///   Old Gold    #D5C23B  → secondary
///   Bright Snow #F4F8F7  → lightest neutral
///   Granite     #48584C  → mid neutral
abstract final class HMTTheme {
  HMTTheme._();

  static const Color _deepForest = Color(0xFF1F4228);
  static const Color _oldGold = Color(0xFFD5C23B);
  static const Color _brightSnow = Color(0xFFF4F8F7);
  static const Color _granite = Color(0xFF48584C);

  static final PRFThemeConfig light = PRFThemeConfig(
    primaryColor: _deepForest,
    secondaryColor: _oldGold,
    primaryPalette: PRFColorUtils.generatePalette(_deepForest),
    secondaryPalette: PRFColorUtils.generatePalette(_oldGold),
    neutralPalette: PRFColorUtils.generateNeutralPalette(
      _brightSnow,
      _granite,
    ),
  );

  /// Dark variant with Bright Snow mapped to darkest neutral and
  /// Light Gold used for secondary container backgrounds.
  static final PRFThemeConfig dark = PRFThemeConfig(
    primaryColor: _deepForest,
    secondaryColor: _oldGold,
    primaryPalette: PRFColorUtils.generatePalette(_deepForest),
    secondaryPalette: PRFColorUtils.generatePalette(_oldGold),
    neutralPalette: PRFColorUtils.generateNeutralPalette(
      _brightSnow,
      _granite,
    ),
  );
}
