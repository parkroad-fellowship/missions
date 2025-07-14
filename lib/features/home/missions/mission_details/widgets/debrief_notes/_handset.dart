import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_debrief_note.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/shared_widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebriefNotesViewHandset extends StatefulWidget {
  const DebriefNotesViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<DebriefNotesViewHandset> createState() =>
      _DebriefNotesViewHandsetState();
}

class _DebriefNotesViewHandsetState extends State<DebriefNotesViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetDebriefNotesCubit>().getDebriefNotes(
      missionUlid: missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleStreamWrapper(
      stream: getIt<LocalDBService>().getDebriefNotes(
        missionUlid: missionUlid,
      ),
      nullWidget: PRFEmptyView(
        label: l10n.noNotes,
        description: l10n.noNotesDesc,
        icon: Icons.note_add_outlined,
      ),
      widget: (context, debriefNotes) => RefreshIndicator(
        onRefresh: () => context.read<GetDebriefNotesCubit>().getDebriefNotes(
          missionUlid: missionUlid,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: debriefNotes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) =>
                BeautifulDebriefNoteCard(
                      debriefNote: debriefNotes[index],
                      index: index,
                    )
                    .animate(delay: (index * 100).ms)
                    .fadeIn()
                    .slideX(begin: -0.3, end: 0),
          ),
        ),
      ),
    );
  }
}

class BeautifulDebriefNoteCard extends StatelessWidget with TimezoneMixin {
  const BeautifulDebriefNoteCard({
    required this.debriefNote,
    required this.index,
    super.key,
  });

  final PRFLocalDebriefNote debriefNote;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: .04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with note icon and timestamp
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    _buildTimestampChip(theme),
                  ],
                ),
              ),
            ],
          ),

          // Note content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(width: 4),
          Text(
            Misc.formatDateTime(debriefNote.createdAt, timezone),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
