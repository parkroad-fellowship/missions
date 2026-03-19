import 'package:app/features/home/missions/mission_details/widgets/souls/actions/soul_form/_handset.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

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
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => SoulFormViewHandset(
        missionUlid: missionUlid,
        soul: soul,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => SoulFormViewHandset(
          missionUlid: missionUlid,
          soul: soul,
        ),
      ),
    );
  }
}
