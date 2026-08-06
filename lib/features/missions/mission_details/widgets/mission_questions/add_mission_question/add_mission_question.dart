import 'package:app/features/missions/mission_details/widgets/mission_questions/add_mission_question/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddMissionQuestionView extends StatelessWidget {
  const AddMissionQuestionView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => AddMissionQuestionViewHandset(missionUlid: missionUlid),
      builder: (_, _) =>
          AddMissionQuestionViewHandset(missionUlid: missionUlid),
    );
  }
}
