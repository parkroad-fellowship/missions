import 'package:app/features/home/missions/mission_details/widgets/souls/actions/update_soul/_handset.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class UpdateSoulView extends StatelessWidget {
  const UpdateSoulView({
    required this.soul,
    required this.missionUlid,
    super.key,
  });

  final PRFSoul soul;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => UpdateSoulViewHandset(
        soul: soul,
        missionUlid: missionUlid,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => UpdateSoulViewHandset(
          soul: soul,
          missionUlid: missionUlid,
        ),
      ),
    );
  }
}
