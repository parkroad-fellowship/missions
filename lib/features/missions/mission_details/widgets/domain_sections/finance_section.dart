import 'package:app/features/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Finance domain section with Requisitions and Expenses tabs.
class FinanceSection extends StatelessWidget {
  const FinanceSection({
    required this.requisitionsTab,
    required this.expensesTab,
    super.key,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  final Widget requisitionsTab;
  final Widget expensesTab;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: context.l10n.finances,
      subtitle: context.l10n.requisitionsAndExpenseTrackingForThisMission,
      onTabChanged: onTabChanged,
      initialIndex: initialIndex,
      tabs: const [
        Tab(text: 'Expenses'),
        Tab(text: 'Requisitions'),
      ],
      children: [
        expensesTab,
        requisitionsTab,
      ],
    );
  }
}
