import 'package:app/features/missions/mission_details/widgets/debrief_notes/actions/debrief_note_form/debrief_note_form.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/record_sections.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class DebriefNotesViewHandset extends StatefulWidget {
  const DebriefNotesViewHandset({required this.mission, super.key});

  final PRFMission mission;

  @override
  State<DebriefNotesViewHandset> createState() =>
      _DebriefNotesViewHandsetState();
}

class _DebriefNotesViewHandsetState extends State<DebriefNotesViewHandset>
    with TimezoneMixin {
  PRFMission get mission => widget.mission;

  Future<void> _showAddDebriefNoteSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.addDebriefNote,
      child: DebriefNoteFormView(missionUlid: mission.ulid),
    );
  }

  Future<void> _showEditDebriefNoteSheet(PRFDebriefNote debriefNote) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: DebriefNoteFormView(
        missionUlid: mission.ulid,
        debriefNote: debriefNote,
      ),
    );
  }

  Future<void> _deleteDebriefNote(PRFDebriefNote debriefNote) async {
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${context.l10n.delete} ${context.l10n.note}',
      message: context.l10n.continueConfirm,
      confirmLabel: context.l10n.delete,
      isDestructive: true,
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<DebriefNoteResourceCubit>().deleteDebriefNote(
      debriefNote.ulid,
    );
    if (!mounted) return;

    final error = context.read<DebriefNoteResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );
    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }
    PRFSnackbar.success(context, context.l10n.debriefNoteDeleted);
  }

  Future<void> _loadDebriefNotes() {
    return context.read<DebriefNoteResourceCubit>().loadAll(
      filters: {'mission_ulid': mission.ulid},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<DebriefNoteResourceCubit, ResourceState<PRFDebriefNote>>(
      builder: (context, state) {
        final debriefNotes = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          mutating: (items, _) => items,
          error: (_, items) => items,
          orElse: () => <PRFDebriefNote>[],
        );
        final error = state.mapOrNull(
          error: (state) => state.message,
        );
        final isLoading = state.maybeWhen(
          listLoading: (_) => true,
          orElse: () => false,
        );

        return MissionResourceTabView(
          isLoading: isLoading,
          error: error,
          isEmpty: debriefNotes.isEmpty,
          onRefresh: _loadDebriefNotes,
          onAdd: _showAddDebriefNoteSheet,
          canEdit: mission.canEdit,
          addButtonLabel: l10n.addDebriefNote,
          addButtonIcon: Icons.rate_review_outlined,
          emptyLabel: l10n.noNotes,
          emptyDescription: l10n.noNotesDesc,
          sectionTitle: l10n.debriefNotesTitle,
          items: debriefNotes.asMap().entries.map((entry) {
            final index = entry.key;
            final debriefNote = entry.value;
            return MissionResourceCard(
                  canEdit: mission.canEdit,
                  title: debriefNote.note.isEmpty
                      ? l10n.untitledNote
                      : debriefNote.note,
                  subtitle: l10n.capturedAt(
                    DateFormatter.formatDateTime(
                      debriefNote.createdAt,
                      timezone,
                    ),
                  ),
                  editTooltip: l10n.editDebriefTooltip,
                  onEdit: () => _showEditDebriefNoteSheet(debriefNote),
                  deleteTooltip: l10n.deleteDebriefTooltip,
                  onDelete: () => _deleteDebriefNote(debriefNote),
                )
                .animate(delay: (index * 100).ms)
                .fadeIn()
                .slideX(begin: -0.3, end: 0);
          }).toList(),
        );
      },
    );
  }
}
