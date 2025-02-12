import 'package:app/features/home/missions/mission_details/widgets/sessions/session/_handset.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class SessionPage extends StatelessWidget {
  const SessionPage({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => SessionPageHandset(
        missionSession: missionSession,
        missionUlid: missionUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => SessionPageHandset(
          missionSession: missionSession,
          missionUlid: missionUlid,
        ),
      ),
    );
  }
}
