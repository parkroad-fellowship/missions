import 'package:app/features/missions/mission_details/widgets/mission_questions/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MissionQuestionsView extends StatelessWidget {
  const MissionQuestionsView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) =>
          MissionQuestionsViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) =>
            MissionQuestionsViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
