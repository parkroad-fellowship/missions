import 'package:app/features/missions/mission_details/widgets/expenses/actions/add_expense/_handset.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class AddExpenseView extends StatelessWidget {
  const AddExpenseView({required this.accountingEventUlid, super.key});

  final String accountingEventUlid;

  @override
  Widget build(BuildContext context) {
    return PRFAdaptive(
      builder: (_, _) =>
          AddExpenseViewHandset(accountingEventUlid: accountingEventUlid),
    );
  }
}
