import 'package:flutter/foundation.dart';

class LandingActionItem {
  const LandingActionItem({
    required this.title,
    required this.assetPath,
    required this.onTap,
    required this.animationDelay,
    this.isVisible = true,
  });

  final String title;
  final String assetPath;
  final VoidCallback onTap;
  final int animationDelay;
  final bool isVisible;
}
