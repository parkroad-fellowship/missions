import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// People data domain section with tabs for Sessions and Souls.
class PeopleDataSection extends StatelessWidget {
  const PeopleDataSection({
    required this.sessionsTab,
    required this.soulsTab,
    super.key,
  });

  final Widget sessionsTab;
  final Widget soulsTab;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'People',
      subtitle: 'Sessions and souls tracked in this mission.',
      tabs: const [
        Tab(text: 'Sessions'),
        Tab(text: 'Souls'),
      ],
      children: [sessionsTab, soulsTab],
    );
  }
}
