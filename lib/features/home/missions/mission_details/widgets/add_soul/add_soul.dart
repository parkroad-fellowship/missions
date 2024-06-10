import 'package:app/features/home/missions/mission_details/widgets/add_soul/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddSoulView extends StatelessWidget {
  const AddSoulView({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => AddSoulViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => AddSoulViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
