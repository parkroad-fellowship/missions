import 'package:app/features/missions/mission_details/widgets/mission_ground/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MissionGroundView extends StatelessWidget {
  const MissionGroundView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) =>
          MissionGroundViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => MissionGroundViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
