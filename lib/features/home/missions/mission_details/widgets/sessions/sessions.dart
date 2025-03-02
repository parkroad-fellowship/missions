import 'package:app/features/home/missions/mission_details/widgets/sessions/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class SessionsView extends StatelessWidget {
  const SessionsView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => SessionsViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => SessionsViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
