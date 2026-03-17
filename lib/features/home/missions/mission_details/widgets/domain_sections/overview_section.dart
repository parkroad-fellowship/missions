import 'package:app/features/home/missions/mission_details/widgets/mission_ground/mission_ground.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:flutter/material.dart';

/// Overview section that displays mission ground info and subscribers
/// as a vertical list (no tabs needed since these are conceptually
/// part of the same "overview" domain).
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              MissionGroundView(missionUlid: missionUlid),
              SubscribersView(missionUlid: missionUlid),
            ],
          ),
        ),
      ],
    );
  }
}
