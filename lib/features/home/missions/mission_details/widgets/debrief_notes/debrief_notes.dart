import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class DebriefNotesView extends StatelessWidget {
  const DebriefNotesView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, _) => DebriefNotesViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => DebriefNotesViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
