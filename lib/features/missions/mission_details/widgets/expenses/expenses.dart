import 'package:app/features/missions/mission_details/widgets/expenses/_handset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({
    required this.canEdit,
    required this.accountingEventUlid,
    super.key,
  });

  final String? accountingEventUlid;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, _) => ExpensesViewHandset(
        accountingEventUlid: accountingEventUlid,
        canEdit: canEdit,
      ),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, _) => ExpensesViewHandset(
          accountingEventUlid: accountingEventUlid,
          canEdit: canEdit,
        ),
      ),
    );
  }
}
