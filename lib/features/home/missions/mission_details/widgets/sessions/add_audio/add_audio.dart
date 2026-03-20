import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddAudioView extends StatelessWidget {
  const AddAudioView({
    required this.missionUlid,
    required this.missionSessionUlid,
    super.key,
  });

  final String missionSessionUlid;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => AddAudioViewHandset(
        missionSessionUlid: missionSessionUlid,
        missionUlid: missionUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddAudioViewHandset(
          missionSessionUlid: missionSessionUlid,
          missionUlid: missionUlid,
        ),
      ),
    );
  }
}
