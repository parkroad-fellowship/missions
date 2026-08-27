import 'package:app/features/missions/mission_details/widgets/subscribers/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class SubscribersView extends StatelessWidget {
  const SubscribersView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => SubscribersViewHandset(missionUlid: missionUlid),
      builder: (_, _) => SubscribersViewHandset(missionUlid: missionUlid),
    );
  }
}
