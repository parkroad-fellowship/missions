import 'package:app/features/missions/mission_details/widgets/gallery/actions/add_media/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddMediaView extends StatelessWidget {
  const AddMediaView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => AddMediaViewHandset(missionUlid: missionUlid),
      builder: (_, _) => AddMediaViewHandset(missionUlid: missionUlid),
    );
  }
}
