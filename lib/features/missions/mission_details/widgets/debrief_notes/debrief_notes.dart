import 'package:app/features/missions/mission_details/widgets/debrief_notes/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class DebriefNotesView extends StatelessWidget {
  const DebriefNotesView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => DebriefNotesViewHandset(mission: mission),
      builder: (_, _) => DebriefNotesViewHandset(mission: mission),
    );
  }
}
