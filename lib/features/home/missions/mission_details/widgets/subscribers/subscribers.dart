import 'package:app/features/home/missions/mission_details/widgets/subscribers/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class SubscribersView extends StatelessWidget {
  const SubscribersView({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) =>
          SubscribersViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => SubscribersViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
