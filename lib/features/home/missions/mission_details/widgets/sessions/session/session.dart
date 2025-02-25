import 'package:app/features/home/missions/mission_details/widgets/sessions/session/_handset.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

@RoutePage()
class SessionPage extends StatelessWidget {
  const SessionPage({
    @PathParam('missionSessionUlid') required this.missionSessionUlid,
    @PathParam('missionUlid') required this.missionUlid,
    @PathParam('missionSessionId') required this.missionSessionId,
    super.key,
  });

  final String missionSessionUlid;
  final String missionUlid;
  final int missionSessionId;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, __) => SessionPageHandset(
            missionSessionUlid: missionSessionUlid,
            missionUlid: missionUlid,
            missionSessionId: missionSessionId,
          ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset:
            (_, __) => SessionPageHandset(
              missionSessionUlid: missionSessionUlid,
              missionUlid: missionUlid,
              missionSessionId: missionSessionId,
            ),
      ),
    );
  }
}
