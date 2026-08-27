import 'package:app/features/missions/mission_details/widgets/debrief_notes/actions/debrief_note_form/debrief_note_form.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/actions/add_expense/add_expense.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/session_form.dart';
import 'package:app/features/missions/mission_details/widgets/souls/actions/soul_form/soul_form.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class FABConfig {
  const FABConfig({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.visible = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool visible;
}

FABConfig getFABConfig({
  required BuildContext context,
  required AppLocalizations l10n,
  required PRFMission mission,
  required String missionUlid,
  required int mainTabIndex,
  required Map<int, int> subTabIndexes,
}) {
  final subTabIndex = subTabIndexes[mainTabIndex] ?? 0;

  switch (mainTabIndex) {
    case 0: // Overview
      if (subTabIndex == 2) {
        // Sessions
        return FABConfig(
          icon: Icons.add_task_rounded,
          label: l10n.addSession,
          onPressed: () => PRFBottomSheet.show<void>(
            context,
            title: l10n.addSession,
            child: SessionFormView(missionUlid: missionUlid),
          ),
        );
      }
      // Default for Overview: Subscribe
      return FABConfig(
        icon: Icons.hail_rounded,
        label: l10n.sendMe,
        onPressed: () {}, // Handled by subscribe consumer
      );

    case 1: // Feedback Data
      switch (subTabIndex) {
        case 0: // Debrief Notes
          return FABConfig(
            icon: Icons.note_add_rounded,
            label: l10n.addDebriefNote,
            onPressed: () => PRFBottomSheet.show<void>(
              context,
              title: l10n.addDebriefNote,
              child: DebriefNoteFormView(missionUlid: missionUlid),
            ),
          );
        case 1: // Souls
          return FABConfig(
            icon: Icons.person_add_rounded,
            label: l10n.addSoul,
            onPressed: () => PRFBottomSheet.show<void>(
              context,
              title: l10n.addSoul,
              child: SoulFormView(
                missionUlid: missionUlid,
                institutionType: mission.school?.institutionType,
              ),
            ),
          );
        case 2: // Questions
          return FABConfig(
            icon: Icons.quiz_rounded,
            label: l10n.addQuestion,
            onPressed: () => PRFBottomSheet.show<void>(
              context,
              title: l10n.addQuestion,
              child: AddMissionQuestionView(missionUlid: missionUlid),
            ),
          );
        case 3: // Gallery
          return FABConfig(
            icon: Icons.add_photo_alternate_rounded,
            label: l10n.addMissionPhotos,
            onPressed: () => PRFBottomSheet.show<void>(
              context,
              title: l10n.addMissionPhotos,
              child: AddMediaView(missionUlid: missionUlid),
            ),
          );
        default:
          return FABConfig(
            icon: Icons.add,
            label: '',
            onPressed: () {},
            visible: false,
          );
      }

    case 2: // Finance
      if (subTabIndex == 0) {
        // Expenses
        final accountingEventUlid = mission.accountingEvent?.ulid;
        return FABConfig(
          icon: Icons.add_card_rounded,
          label: l10n.addExpense,
          onPressed: () {
            if (accountingEventUlid != null) {
              PRFBottomSheet.show<void>(
                context,
                title: l10n.addExpense,
                child: AddExpenseView(
                  accountingEventUlid: accountingEventUlid,
                ),
              );
            }
          },
          visible: accountingEventUlid != null,
        );
      }
      return FABConfig(
        icon: Icons.add,
        label: '',
        onPressed: () {},
        visible: false,
      );
  }

  // Default: hidden
  return FABConfig(
    icon: Icons.add,
    label: '',
    onPressed: () {},
    visible: false,
  );
}
