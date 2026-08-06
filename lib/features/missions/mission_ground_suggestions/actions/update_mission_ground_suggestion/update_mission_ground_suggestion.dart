import 'package:app/features/missions/mission_ground_suggestions/actions/update_mission_ground_suggestion/_handset.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class UpdateMissionGroundSuggestionView extends StatelessWidget {
  const UpdateMissionGroundSuggestionView({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => UpdateMissionGroundSuggestionViewHandset(
        missionGroundSuggestion: missionGroundSuggestion,
      ),
      builder: (_, _) => UpdateMissionGroundSuggestionViewHandset(
        missionGroundSuggestion: missionGroundSuggestion,
      ),
    );
  }
}
