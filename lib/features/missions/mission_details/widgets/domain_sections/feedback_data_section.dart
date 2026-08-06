import 'package:app/features/missions/mission_details/widgets/domain_sections/prf_domain_tab_section.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Feedback data domain section with tabs for Debrief Notes, Souls,
/// and Questions.
class FeedbackDataSection extends StatelessWidget {
  const FeedbackDataSection({
    required this.debriefNotesTab,
    required this.soulsTab,
    required this.questionsTab,
    required this.galleryTab,
    super.key,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  final Widget debriefNotesTab;
  final Widget soulsTab;
  final Widget questionsTab;
  final Widget galleryTab;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PRFDomainTabSection(
      title: context.l10n.feedbackData,
      subtitle: context.l10n.questionsCapturedAndPostMissionDebriefReflections,
      onTabChanged: onTabChanged,
      initialIndex: initialIndex,
      tabs: [
        Tab(text: l10n.debriefNotes),
        Tab(text: l10n.souls),
        Tab(text: l10n.missionQuestions),
        Tab(text: l10n.gallery),
      ],
      children: [debriefNotesTab, soulsTab, questionsTab, galleryTab],
    );
  }
}
