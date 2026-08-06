import 'package:app/features/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Overview section that displays mission ground info, subscribers,
/// and sessions as tabs using PRFDomainTabSection.
class OverviewSection extends StatelessWidget {
  const OverviewSection({
    required this.missionGround,
    required this.subscribers,
    required this.sessions,
    super.key,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  final Widget missionGround;
  final Widget subscribers;
  final Widget sessions;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: context.l10n.overview,
      subtitle: context.l10n.missionContextTeamMembersAndSessions,
      onTabChanged: onTabChanged,
      initialIndex: initialIndex,
      tabs: const [
        Tab(text: 'Mission Ground'),
        Tab(text: 'Subscribers'),
        Tab(text: 'Sessions'),
      ],
      children: [missionGround, subscribers, sessions],
    );
  }
}
