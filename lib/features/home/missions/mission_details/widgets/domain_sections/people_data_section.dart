import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// People data domain section with a single Sessions tab.
class PeopleDataSection extends StatelessWidget {
  const PeopleDataSection({required this.sessionsTab, super.key});

  final Widget sessionsTab;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'People',
      subtitle: 'Sessions tracked in this mission.',
      tabs: const [Tab(text: 'Sessions')],
      children: [sessionsTab],
    );
  }
}
