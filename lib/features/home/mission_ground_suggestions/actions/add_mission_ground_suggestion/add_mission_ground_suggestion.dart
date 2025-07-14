import 'package:app/features/home/mission_ground_suggestions/actions/add_mission_ground_suggestion/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddMissionGroundSuggestionView extends StatelessWidget {
  const AddMissionGroundSuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => const AddMissionGroundSuggestionViewHandset(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => const AddMissionGroundSuggestionViewHandset(),
      ),
    );
  }
}
