import 'package:app/features/home/wrapped/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

/// Letterboxed cinematic stage for the wrapped experience on tablets:
/// the handset 9:16 presentation is centered on an obsidian backdrop so
/// the stats film reads identically at every tablet size.
class MissionsWrappedTablet extends StatelessWidget {
  const MissionsWrappedTablet({super.key});

  /// Width of the letterboxed stage.
  static const double _stageWidth = 450;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRFColors.navy900,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _stageWidth),
          child: const AspectRatio(
            aspectRatio: 9 / 16,
            child: ClipRect(
              child: MissionsWrappedHandset(),
            ),
          ),
        ),
      ),
    );
  }
}
