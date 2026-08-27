import 'package:app/features/missions/mission_details/widgets/sessions/add_audio/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

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
    return PRFAdaptive(
      handset: (_) => AddAudioViewHandset(
        missionSessionUlid: missionSessionUlid,
        missionUlid: missionUlid,
      ),
      builder: (_, _) => AddAudioViewHandset(
        missionSessionUlid: missionSessionUlid,
        missionUlid: missionUlid,
      ),
    );
  }
}
