import 'package:app/features/missions/mission_details/widgets/mission_questions/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MissionQuestionsView extends StatelessWidget {
  const MissionQuestionsView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => MissionQuestionsViewHandset(mission: mission),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => MissionQuestionsViewHandset(mission: mission),
      ),
    );
  }
}
