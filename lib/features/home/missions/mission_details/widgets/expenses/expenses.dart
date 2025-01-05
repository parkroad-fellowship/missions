import 'package:app/features/home/missions/mission_details/widgets/expenses/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => ExpensesViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => ExpensesViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
