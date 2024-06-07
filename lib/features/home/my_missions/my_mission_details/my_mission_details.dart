import 'package:app/features/home/my_missions/my_mission_details/_handset.dart';
import 'package:app/models/prf_mission.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class MyMissionsDetailsPage extends StatelessWidget {
  const MyMissionsDetailsPage({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => MyMissionsDetailsPageHandset(mission: mission),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => MyMissionsDetailsPageHandset(mission: mission),
      ),
    );
  }
}
