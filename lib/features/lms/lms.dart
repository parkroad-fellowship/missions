import 'package:app/features/lms/_handset.dart';
import 'package:app/features/lms/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class LMSPage extends StatelessWidget {
  const LMSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const LMSPageTablet(),
      handset: (context) => const LMSPageHandset(),
      tablet: (context) => const LMSPageTablet(),
    );
  }
}
