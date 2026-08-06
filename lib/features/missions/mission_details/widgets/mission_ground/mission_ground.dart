import 'package:app/features/missions/mission_details/widgets/mission_ground/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class MissionGroundView extends StatelessWidget {
  const MissionGroundView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => MissionGroundViewHandset(missionUlid: missionUlid),
      builder: (_, _) => MissionGroundViewHandset(missionUlid: missionUlid),
    );
  }
}
