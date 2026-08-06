import 'package:app/features/missions/mission_details/widgets/sessions/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class SessionsView extends StatelessWidget {
  const SessionsView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => SessionsViewHandset(mission: mission),
      builder: (_, _) => SessionsViewHandset(mission: mission),
    );
  }
}
