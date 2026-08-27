import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class LandingActionTile extends StatelessWidget {
  const LandingActionTile({
    required this.title,
    required this.assetPath,
    required this.onTap,
    super.key,
    this.assetHeight = 56,
    this.isNeutralCard = false,
    this.isAccent = false,
  });

  final String title;
  final String assetPath;
  final VoidCallback onTap;
  final double assetHeight;
  final bool isNeutralCard;
  final bool isAccent;

  @override
  Widget build(_) {
    return PRFNavigationTile(
      title: title,
      assetPath: assetPath,
      onTap: onTap,
      assetHeight: assetHeight,
      isNeutralCard: isNeutralCard,
      accent: isAccent,
    );
  }
}
