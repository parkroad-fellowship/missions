import 'package:app/features/home/missions/mission_details/widgets/add_mission_question/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_soul/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddMissionQuestionView extends StatelessWidget {
  const AddMissionQuestionView({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) =>
          AddMissionQuestionViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) =>
            AddMissionQuestionViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
