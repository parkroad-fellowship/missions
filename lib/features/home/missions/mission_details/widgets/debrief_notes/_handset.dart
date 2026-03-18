import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/actions/add_debrief_note/add_debrief_note.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/actions/update_debrief_note/update_debrief_note.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/utils/_index.dart';
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

class _DebriefNotesViewHandsetState extends State<DebriefNotesViewHandset> {
  String get missionUlid => widget.missionUlid;

  Future<void> _showAddDebriefNoteSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.addDebriefNote,
      child: AddDebriefNoteView(missionUlid: missionUlid),
    );
  }

  Future<void> _showEditDebriefNoteSheet(PRFDebriefNote debriefNote) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: UpdateDebriefNoteView(
        debriefNote: debriefNote,
        missionUlid: missionUlid,
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
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.sm,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.md,
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: PRFPrimaryButton(
            onPressed: _showAddDebriefNoteSheet,
            title: l10n.addDebriefNote,
            disabled: false,
          ),
        ),
        Expanded(
          child:
              BlocBuilder<
                DebriefNoteResourceCubit,
                ResourceState<PRFDebriefNote>
              >(
                builder: (context, state) {
                  return state.maybeWhen(
                    listLoading: () => const Center(
                      child: PRFCircularProgressIndicator(),
                    ),
                    listLoaded: (debriefNotes, _, _) {
                      if (debriefNotes.isEmpty) {
                        return PRFEmptyView(
                          label: l10n.noNotes,
                          description: l10n.noNotesDesc,
                          icon: Icons.note_add_outlined,
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () =>
                            context.read<DebriefNoteResourceCubit>().loadAll(
                              filters: {'mission_ulid': missionUlid},
                            ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              vertical: PRFSpacingTokens.lg,
                            ),
                            itemCount: debriefNotes.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0),
                            itemBuilder: (context, index) =>
                                BeautifulDebriefNoteCard(
                                      debriefNote: debriefNotes[index],
                                      index: index,
                                      onEdit: () => _showEditDebriefNoteSheet(
                                        debriefNotes[index],
                                      ),
                                      onDelete: () => _deleteDebriefNote(
                                        debriefNotes[index],
                                      ),
                                    )
                                    .animate(delay: (index * 100).ms)
                                    .fadeIn()
                                    .slideX(begin: -0.3, end: 0),
                          ),
                        ),
                      );
                    },
                    error: (message, _) => PRFEmptyView(
                      label: l10n.noNotes,
                      description: message,
                      icon: Icons.note_add_outlined,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
        ),
      ],
    );
  }
}

class BeautifulDebriefNoteCard extends StatelessWidget with TimezoneMixin {
  const BeautifulDebriefNoteCard({
    required this.debriefNote,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PRFDebriefNote debriefNote;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      margin: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                ),
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debrief Note',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.xs),
                    _buildTimestampChip(theme),
                  ],
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              SizedBox(
                width: 72,
                child: PRFSecondaryButton(
                  onPressed: onEdit,
                  title: context.l10n.edit,
                  disabled: false,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              SizedBox(
                width: 76,
                child: PRFDestroyButton(
                  onPressed: onDelete,
                  title: context.l10n.delete,
                  disabled: false,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              debriefNote.note,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate(effects: const [SaturateEffect()]);
  }

  Widget _buildTimestampChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            DateFormatter.formatDateTime(debriefNote.createdAt, timezone),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
