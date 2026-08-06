import 'package:app/features/missions/mission_details/widgets/souls/_handset.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class SoulsView extends StatelessWidget {
  const SoulsView({required this.mission, super.key});

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => SoulsViewHandset(mission: mission),
      builder: (_, _) => SoulsViewHandset(mission: mission),
    );
  }
}
