import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/_handset.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

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
    return PRFAdaptive(
      handset: (_) => SessionFormViewHandset(
        missionUlid: missionUlid,
        missionSession: missionSession,
      ),
      builder: (_, _) => SessionFormViewHandset(
        missionUlid: missionUlid,
        missionSession: missionSession,
      ),
    );
  }
}
