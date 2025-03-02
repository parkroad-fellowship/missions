import 'package:app/features/home/missions/mission_details/widgets/sessions/add_audio/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddAudioView extends StatelessWidget {
  const AddAudioView({required this.missionSessionUlid, super.key});

  final String missionSessionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder:
          (_, _) => AddAudioViewHandset(missionSessionUlid: missionSessionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset:
            (_, _) =>
                AddAudioViewHandset(missionSessionUlid: missionSessionUlid),
      ),
    );
  }
}
