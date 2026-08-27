import 'package:app/features/missions/mission_ground_suggestions/actions/add_mission_ground_suggestion/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddMissionGroundSuggestionView extends StatelessWidget {
  const AddMissionGroundSuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => const AddMissionGroundSuggestionViewHandset(),
      builder: (_, _) => const AddMissionGroundSuggestionViewHandset(),
    );
  }
}
