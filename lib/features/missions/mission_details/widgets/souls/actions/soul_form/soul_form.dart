import 'package:app/features/missions/mission_details/widgets/souls/actions/soul_form/_handset.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class SoulFormView extends StatelessWidget {
  const SoulFormView({
    required this.missionUlid,
    this.soul,
    super.key,
  });

  final String missionUlid;
  final PRFSoul? soul;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      handset: (_) => SoulFormViewHandset(
        missionUlid: missionUlid,
        soul: soul,
      ),
      builder: (_, _) => SoulFormViewHandset(
        missionUlid: missionUlid,
        soul: soul,
      ),
    );
  }
}
