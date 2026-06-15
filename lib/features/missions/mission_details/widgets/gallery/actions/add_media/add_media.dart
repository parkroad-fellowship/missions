import 'package:app/features/missions/mission_details/widgets/gallery/actions/add_media/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddMediaView extends StatelessWidget {
  const AddMediaView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => AddMediaViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddMediaViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
