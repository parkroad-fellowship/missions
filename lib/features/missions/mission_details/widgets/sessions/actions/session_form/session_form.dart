import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/_handset.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class SessionFormView extends StatelessWidget {
  const SessionFormView({
    required this.missionUlid,
    this.missionSession,
    super.key,
  });

  final String missionUlid;
  final PRFMissionSession? missionSession;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => SessionFormViewHandset(
        missionUlid: missionUlid,
        missionSession: missionSession,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => SessionFormViewHandset(
          missionUlid: missionUlid,
          missionSession: missionSession,
        ),
      ),
    );
  }
}
