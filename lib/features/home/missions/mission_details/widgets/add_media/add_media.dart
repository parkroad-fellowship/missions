import 'package:app/features/home/missions/mission_details/widgets/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_media/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddMediaView extends StatelessWidget {
  const AddMediaView({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) =>
          AddMediaViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => AddMediaViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
