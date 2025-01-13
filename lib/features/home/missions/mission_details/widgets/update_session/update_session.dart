import 'package:app/features/home/missions/mission_details/widgets/add_session/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/update_session/_handset.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateSessionView extends StatelessWidget {
  const UpdateSessionView({
    required this.missionUlid,
    required this.missionSession,
    super.key,
  });

  final String missionUlid;
  final PRFMissionSession missionSession;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => UpdateSessionViewHandset(
        missionUlid: missionUlid,
        missionSession: missionSession,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => UpdateSessionViewHandset(
          missionUlid: missionUlid,
          missionSession: missionSession,
        ),
      ),
    );
  }
}
