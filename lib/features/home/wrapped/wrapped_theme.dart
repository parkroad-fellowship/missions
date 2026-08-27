import 'package:flutter/material.dart';

class WrappedPalette {
  const WrappedPalette({
    required this.base,
    required this.blobs,
    required this.accent,
    required this.glyph,
  });

  final Color base;
  final List<Color> blobs;
  final Color accent;
  final IconData glyph;
}

abstract final class WrappedPalettes {
  static const intro = WrappedPalette(
    base: Color(0xFF0E0A26),
    blobs: [Color(0xFF6E4CEB), Color(0xFF2B1E6E), Color(0xFF9DE35D)],
    accent: Color(0xFF9DE35D),
    glyph: Icons.auto_awesome_rounded,
  );

  static const missions = WrappedPalette(
    base: Color(0xFF071108),
    blobs: [Color(0xFF9DE35D), Color(0xFF12B886), Color(0xFF4B6D2A)],
    accent: Color(0xFFAFE964),
    glyph: Icons.explore_rounded,
  );

  static const impact = WrappedPalette(
    base: Color(0xFF190A0E),
    blobs: [Color(0xFFEB8B2D), Color(0xFFE0338C), Color(0xFF7A1F4D)],
    accent: Color(0xFFFFB37A),
    glyph: Icons.favorite_rounded,
  );

  static const learning = WrappedPalette(
    base: Color(0xFF051226),
    blobs: [Color(0xFF296DFF), Color(0xFF00B8D9), Color(0xFF123C8F)],
    accent: Color(0xFF62D9FF),
    glyph: Icons.school_rounded,
  );

  static const prayer = WrappedPalette(
    base: Color(0xFF130A26),
    blobs: [Color(0xFFB388FF), Color(0xFF6E4CEB), Color(0xFF3A1F6E)],
    accent: Color(0xFFCBAEFF),
    glyph: Icons.volunteer_activism_rounded,
  );

  static const events = WrappedPalette(
    base: Color(0xFF22080F),
    blobs: [Color(0xFFFF4E78), Color(0xFFFF8A5C), Color(0xFF8F1D3B)],
    accent: Color(0xFFFF87A8),
    glyph: Icons.emoji_people_rounded,
  );

  static const finale = WrappedPalette(
    base: Color(0xFF090B1F),
    blobs: [Color(0xFF9DE35D), Color(0xFF1A2253), Color(0xFF6E4CEB)],
    accent: Color(0xFF9DE35D),
    glyph: Icons.celebration_rounded,
  );

  static const reflective = WrappedPalette(
    base: Color(0xFF0B0E1C),
    blobs: [Color(0xFF1A2253), Color(0xFF3A2F63), Color(0xFF24406B)],
    accent: Color(0xFFAFC96E),
    glyph: Icons.eco_rounded,
  );
}
