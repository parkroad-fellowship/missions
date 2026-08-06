import 'package:app/features/missions/mission_ground_suggestions/_handset.dart';
import 'package:app/features/missions/mission_ground_suggestions/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class MissionGroundSuggestionsPage extends StatelessWidget {
  const MissionGroundSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (context, _) => const MissionGroundSuggestionsPageHandset(),
      handset: (context) => const MissionGroundSuggestionsPageHandset(),
      tablet: (context) => const MissionGroundSuggestionsPageTablet(),
    );
  }
}
