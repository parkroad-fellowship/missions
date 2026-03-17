import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// Finance domain section with a single Expenses tab.
class FinanceSection extends StatelessWidget {
  const FinanceSection({
    required this.expensesTab,
    super.key,
  });

  final Widget expensesTab;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'Finances',
      subtitle: 'Expense tracking for this mission.',
      tabs: const [
        Tab(text: 'Expenses'),
      ],
      children: [expensesTab],
    );
  }
}
