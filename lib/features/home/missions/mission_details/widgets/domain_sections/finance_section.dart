import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// Finance domain section with Requisitions and Expenses tabs.
class FinanceSection extends StatelessWidget {
  const FinanceSection({
    required this.requisitionsTab,
    required this.expensesTab,
    super.key,
  });

  final Widget requisitionsTab;
  final Widget expensesTab;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'Finances',
      subtitle: 'Requisitions and expense tracking for this mission.',
      tabs: const [
        Tab(text: 'Requisitions'),
        Tab(text: 'Expenses'),
      ],
      children: [requisitionsTab, expensesTab],
    );
  }
}
