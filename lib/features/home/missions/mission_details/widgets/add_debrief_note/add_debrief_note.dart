import 'package:app/features/home/missions/mission_details/widgets/add_debrief_note/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddDebriefNoteView extends StatelessWidget {
  const AddDebriefNoteView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, _) => AddDebriefNoteViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddDebriefNoteViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
