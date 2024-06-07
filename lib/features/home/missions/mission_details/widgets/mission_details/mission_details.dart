import 'package:app/features/home/missions/mission_details/widgets/mission_details/_handset.dart';
import 'package:app/models/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MissionDetailsView extends StatelessWidget {
  const MissionDetailsView({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => MissionDetailsViewHandset(mission: mission),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => MissionDetailsViewHandset(mission: mission),
      ),
    );
  }
}
