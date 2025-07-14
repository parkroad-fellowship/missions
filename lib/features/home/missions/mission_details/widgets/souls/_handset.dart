import 'package:app/enums/prf_soul_decision_type.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_soul.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/shared_widgets/empty_state.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SoulsViewHandset> createState() => _SoulsViewHandsetState();
}

class _SoulsViewHandsetState extends State<SoulsViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetSoulsCubit>().getSouls(missionUlid: missionUlid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleStreamWrapper(
      stream: getIt<LocalDBService>().getSouls(missionUlid: missionUlid),
      nullWidget: Center(
        child: PRFEmptyView(
          label: l10n.noSouls,
          description: l10n.noSoulsDesc,
          icon: Icons.people_outline_rounded,
        ),
      ),
      widget: (context, souls) => RefreshIndicator(
        onRefresh: () =>
            context.read<GetSoulsCubit>().getSouls(missionUlid: missionUlid),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: souls.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) =>
                BeautifulSoulCard(
                      soul: souls[index],
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

class BeautifulSoulCard extends StatelessWidget {
  const BeautifulSoulCard({
    required this.soul,
    required this.index,
    super.key,
  });

  final PRFLocalSoul soul;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Header with avatar and name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildAvatarIcon(theme),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      soul.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Decision Type Badge
              _buildDecisionTypeBadge(theme),
            ],
          ),

          const SizedBox(height: 16),

          // Additional Information Section
          _buildAdditionalInfo(theme, l10n),

          // Notes Section (if available)
          if (soul.notes != null && soul.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildNotesSection(theme),
          ],

          // Date Information
          const SizedBox(height: 12),
          _buildDateInfo(theme),
        ],
      ),
    ).animate(effects: const [SaturateEffect()]);
  }

  Widget _buildAvatarIcon(ThemeData theme) {
    final initials = Misc.getUserNameInitials(soul.fullName);

    return Text(
      initials,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDecisionTypeBadge(ThemeData theme) {
    final decisionColor = _getDecisionTypeColor(theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: decisionColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: decisionColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getDecisionTypeIcon(),
            size: 14,
            color: decisionColor,
          ),
          const SizedBox(width: 4),
          Text(
            soul.decisionType.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: decisionColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              theme,
              l10n.classGroup,
              soul.classGroup.name!,
              Icons.class_rounded,
            ),
          ),
          if (soul.admissionNumber != null &&
              soul.admissionNumber!.isNotEmpty) ...[
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                theme,
                l10n.admissionNumber,
                soul.admissionNumber!,
                Icons.badge,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_alt,
                size: 14,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Notes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            soul.notes!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(ThemeData theme) {
    final formattedDate = DateFormat(
      'MMM dd, yyyy • HH:mm',
    ).format(soul.createdAt);

    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'Recorded: $formattedDate',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Color _getDecisionTypeColor(ThemeData theme) {
    switch (soul.decisionType) {
      case PRFSoulDecisionType.salvation:
        return theme.colorScheme.tertiary;
      case PRFSoulDecisionType.rededication:
        return theme.colorScheme.secondary;
      case PRFSoulDecisionType.camp:
        return theme.colorScheme.primary;
      case PRFSoulDecisionType.prayer:
        return theme.colorScheme.primaryContainer;
      case PRFSoulDecisionType.other:
        return theme.colorScheme.outline;
    }
  }

  IconData _getDecisionTypeIcon() {
    switch (soul.decisionType) {
      case PRFSoulDecisionType.salvation:
        return Icons.favorite;
      case PRFSoulDecisionType.rededication:
        return Icons.refresh;
      case PRFSoulDecisionType.camp:
        return Icons.house_rounded;
      case PRFSoulDecisionType.prayer:
        return Icons.back_hand_rounded;
      case PRFSoulDecisionType.other:
        return Icons.more_horiz;
    }
  }
}
