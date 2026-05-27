import 'package:app/features/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// Overview section that displays mission ground info, subscribers,
/// and sessions as tabs using PRFDomainTabSection.
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.missionGround,
    required this.subscribers,
    required this.sessions,
    super.key,
  });

  final Widget missionGround;
  final Widget subscribers;
  final Widget sessions;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'Overview',
      subtitle: 'Mission context, team members, and sessions.',
      tabs: const [
        Tab(text: 'Mission Ground'),
        Tab(text: 'Subscribers'),
        Tab(text: 'Sessions'),
      ],
      children: [missionGround, subscribers, sessions],
    );
  }
}
