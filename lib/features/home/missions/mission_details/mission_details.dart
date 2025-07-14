import 'package:app/features/home/missions/mission_details/_handset.dart';
import 'package:app/features/home/missions/mission_details/_tablet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class MissionsDetailsPage extends StatelessWidget {
  const MissionsDetailsPage({
    @PathParam('missionUlid') required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) =>
          MissionsDetailsPageTablet(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => MissionsDetailsPageHandset(missionUlid: missionUlid),
        tablet: (_, _) => MissionsDetailsPageTablet(missionUlid: missionUlid),
      ),
    );
  }
}
