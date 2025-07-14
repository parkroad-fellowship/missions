import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/add_expense/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddExpenseView extends StatelessWidget {
  const AddExpenseView({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => AddExpenseViewHandset(missionUlid: missionUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => AddExpenseViewHandset(missionUlid: missionUlid),
      ),
    );
  }
}
