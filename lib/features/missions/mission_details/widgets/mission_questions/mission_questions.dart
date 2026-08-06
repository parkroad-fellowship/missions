import 'package:app/features/missions/mission_details/widgets/mission_questions/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class MissionQuestionsView extends StatelessWidget {
  const MissionQuestionsView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => MissionQuestionsViewHandset(mission: mission),
      builder: (_, _) => MissionQuestionsViewHandset(mission: mission),
    );
  }
}
