import 'package:app/features/home/mission_ground_suggestions/actions/update_mission_ground_suggestion/_handset.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateMissionGroundSuggestionView extends StatelessWidget {
  const UpdateMissionGroundSuggestionView({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => UpdateMissionGroundSuggestionViewHandset(
        missionGroundSuggestion: missionGroundSuggestion,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => UpdateMissionGroundSuggestionViewHandset(
          missionGroundSuggestion: missionGroundSuggestion,
        ),
      ),
    );
  }
}
