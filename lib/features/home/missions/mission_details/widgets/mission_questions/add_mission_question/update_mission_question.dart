import 'package:app/features/home/missions/mission_details/widgets/mission_questions/add_mission_question/update_mission_question_handset.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateMissionQuestionView extends StatelessWidget {
  const UpdateMissionQuestionView({
    required this.missionQuestion,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionQuestion missionQuestion;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => UpdateMissionQuestionViewHandset(
        missionQuestion: missionQuestion,
        missionUlid: missionUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => UpdateMissionQuestionViewHandset(
          missionQuestion: missionQuestion,
          missionUlid: missionUlid,
        ),
      ),
    );
  }
}
