import 'package:app/features/missions/mission_details/widgets/debrief_notes/actions/debrief_note_form/debrief_note_form.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/record_sections.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class DebriefNotesViewHandset extends StatefulWidget {
  const DebriefNotesViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<DebriefNotesViewHandset> createState() =>
      _DebriefNotesViewHandsetState();
}

class _DebriefNotesViewHandsetState extends State<DebriefNotesViewHandset>
    with TimezoneMixin {
  String get missionUlid => widget.missionUlid;

  Future<void> _showAddDebriefNoteSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.addDebriefNote,
      child: DebriefNoteFormView(missionUlid: missionUlid),
    );
  }

  Future<void> _showEditDebriefNoteSheet(PRFDebriefNote debriefNote) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: DebriefNoteFormView(
        missionUlid: missionUlid,
        debriefNote: debriefNote,
      ),
    );
  }

  Future<void> _deleteDebriefNote(PRFDebriefNote debriefNote) async {
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${context.l10n.delete} ${context.l10n.note}',
      message: 'Are you sure you want to continue?',
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
    PRFSnackbar.success(context, 'Debrief note deleted');
  }

  @override
  void initState() {
    context.read<DebriefNoteResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<DebriefNoteResourceCubit, ResourceState<PRFDebriefNote>>(
      builder: (context, state) {
        final debriefNotes = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          mutating: (items, _) => items,
          mutated: (items, _, _) => items,
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
          onRefresh: () => context.read<DebriefNoteResourceCubit>().loadAll(
            filters: {'mission_ulid': missionUlid},
          ),
          onAdd: _showAddDebriefNoteSheet,
          addButtonLabel: l10n.addDebriefNote,
          addButtonIcon: Icons.rate_review_outlined,
          emptyLabel: l10n.noNotes,
          emptyDescription: l10n.noNotesDesc,
          sectionTitle: 'Debrief Notes',
          items: debriefNotes.asMap().entries.map((entry) {
            final index = entry.key;
            final debriefNote = entry.value;
            return MissionResourceCard(
              title: debriefNote.note.isEmpty
                  ? 'Untitled note'
                  : debriefNote.note,
              subtitle:
                  'Captured ${DateFormatter.formatDateTime(debriefNote.createdAt, timezone)}',
              editTooltip: 'Edit debrief note',
              onEdit: () => _showEditDebriefNoteSheet(debriefNote),
              deleteTooltip: 'Delete debrief note',
              onDelete: () => _deleteDebriefNote(debriefNote),
            ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: -0.3, end: 0);
          }).toList(),
        );
      },
    );
  }
}
