import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

/// Entrance animation for timeline entries: plays once per screen instance,
/// respects the system reduce-motion setting, and caps the stagger so cards
/// scrolled into view appear immediately rather than waiting out a
/// per-index delay.
Widget buildAnimatedTimelineEntry({
  required BuildContext context,
  required int index,
  required bool animate,
  required Widget child,
}) {
  if (!animate || MediaQuery.disableAnimationsOf(context)) {
    return child;
  }

  final cappedIndex = index % 8;

  return child
      .animate()
      .fadeIn(
        delay: Duration(milliseconds: cappedIndex * 60),
        duration: PRFMotionTokens.enterShort,
      )
      .slideX(begin: 0.3, end: 0, curve: PRFMotionTokens.entering);
}
