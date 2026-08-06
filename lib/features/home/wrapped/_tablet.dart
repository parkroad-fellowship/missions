import 'package:app/features/home/wrapped/_handset.dart';
import 'package:flutter/material.dart';

class MissionsWrappedTablet extends StatelessWidget {
  const MissionsWrappedTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark cinematic widescreen background
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
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
