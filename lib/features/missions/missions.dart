import 'package:app/features/missions/_handset.dart';
import 'package:app/features/missions/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const MissionsPageHandset(),
      handset: (context) => const MissionsPageHandset(),
      tablet: (context) => const MissionsPageTablet(),
    );
  }
}
