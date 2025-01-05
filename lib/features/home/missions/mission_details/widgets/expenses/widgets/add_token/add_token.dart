import 'package:app/features/home/missions/mission_details/widgets/expenses/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/widgets/add_token/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class AddTokenView extends StatelessWidget {
  const AddTokenView({
    required this.missionExpenseUlid,
    super.key,
  });

  final String missionExpenseUlid;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => AddTokenViewHandset(missionExpenseUlid: missionExpenseUlid),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => AddTokenViewHandset(missionExpenseUlid: missionExpenseUlid),
      ),
    );
  }
}
