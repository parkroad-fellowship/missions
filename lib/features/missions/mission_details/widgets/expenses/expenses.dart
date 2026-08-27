import 'package:app/features/missions/mission_details/widgets/expenses/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

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
    return PRFAdaptive(
      handset: (_) => ExpensesViewHandset(
        accountingEventUlid: accountingEventUlid,
        canEdit: canEdit,
      ),
      builder: (_, _) => ExpensesViewHandset(
        accountingEventUlid: accountingEventUlid,
        canEdit: canEdit,
      ),
    );
  }
}
