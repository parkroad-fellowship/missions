import 'package:app/features/home/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:flutter/material.dart';

/// Feedback data domain section with tabs for Debrief Notes, Souls,
/// and Questions.
class FeedbackDataSection extends StatelessWidget {
  const FeedbackDataSection({
    required this.debriefNotesTab,
    required this.soulsTab,
    required this.questionsTab,
    super.key,
  });

  final Widget debriefNotesTab;
  final Widget soulsTab;
  final Widget questionsTab;

  @override
  Widget build(BuildContext context) {
    return PRFDomainTabSection(
      title: 'Feedback Data',
      subtitle: 'Questions captured and post-mission debrief reflections.',
      tabs: const [
        Tab(text: 'Debrief Notes'),
        Tab(text: 'Souls'),
        Tab(text: 'Questions'),
      ],
      children: [debriefNotesTab, soulsTab, questionsTab],
    );
  }
}
