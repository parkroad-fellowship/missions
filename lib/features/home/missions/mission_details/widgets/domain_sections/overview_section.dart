import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// Overview section that displays mission ground info and subscribers
/// as tabs using PRFDomainTabSection.
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.missionGround,
    required this.subscribers,
    super.key,
  });

  final Widget missionGround;
  final Widget subscribers;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'Overview',
      subtitle: 'Mission context and team members.',
      tabs: const [
        Tab(text: 'Mission Ground'),
        Tab(text: 'Subscribers'),
      ],
      children: [missionGround, subscribers],
    );
  }
}
