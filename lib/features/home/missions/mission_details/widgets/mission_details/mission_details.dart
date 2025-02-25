import 'package:app/features/home/missions/mission_details/widgets/mission_details/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class MissionDetailsView extends StatelessWidget {
  const MissionDetailsView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, __) => MissionDetailsViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => MissionDetailsViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
