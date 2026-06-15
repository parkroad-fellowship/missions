import 'package:app/features/missions/mission_details/widgets/debrief_notes/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class DebriefNotesView extends StatelessWidget {
  const DebriefNotesView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => DebriefNotesViewHandset(mission: mission),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => DebriefNotesViewHandset(mission: mission),
      ),
    );
  }
}
