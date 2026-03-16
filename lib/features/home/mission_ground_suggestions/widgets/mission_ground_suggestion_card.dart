import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

class MissionGroundSuggestionCard extends StatelessWidget {
  const MissionGroundSuggestionCard({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow..withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow..withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline..withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
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
                      missionGroundSuggestion.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: PRFSpacingTokens.xs),
                    Text(
                      missionGroundSuggestion.contactPerson,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Call button
              if (PermissionHelper.userCan('viewAny mission ground suggestion'))
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.call_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    onPressed: () async {
                      final uri = Uri(
                        scheme: 'tel',
                        path: missionGroundSuggestion.contactNumber,
                      );
                      await UrlHelper.openUrl(uri);
                    },
                  ),
                ).animate(
                  effects: const [
                    ShakeEffect(
                      duration: Duration(seconds: 2),
                      delay: PRFMotionTokens.enterShort,
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: PRFSpacingTokens.lg),

          // Status and additional info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.md,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    context,
                    missionGroundSuggestion.status,
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(missionGroundSuggestion.status),
                      size: 14,
                      color: _getStatusTextColor(
                        context,
                        missionGroundSuggestion.status,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.xs),
                    Text(
                      missionGroundSuggestion.status.name.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusTextColor(
                          context,
                          missionGroundSuggestion.status,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (missionGroundSuggestion.contactNumber.isNotEmpty)
                Text(
                  missionGroundSuggestion.contactNumber,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate(effects: const [SaturateEffect()]);
  }

  Color _getStatusColor(
    BuildContext context,
    PRFMissionGroundSuggestionStatus status,
  ) {
    final statusColors = context.statusColors;
    switch (status) {
      case PRFMissionGroundSuggestionStatus.pending:
        return statusColors.pending.background;
      case PRFMissionGroundSuggestionStatus.initiatedContact:
        return statusColors.initiated.background;
      case PRFMissionGroundSuggestionStatus.visitScheduled:
        return statusColors.scheduled.background;
      case PRFMissionGroundSuggestionStatus.missionScheduled:
        return context.prfColors.purple.withValues(alpha: 0.2);
      case PRFMissionGroundSuggestionStatus.completed:
        return statusColors.completed.background;
      case PRFMissionGroundSuggestionStatus.ignore:
        return statusColors.ignored.background;
    }
  }

  Color _getStatusTextColor(
    BuildContext context,
    PRFMissionGroundSuggestionStatus status,
  ) {
    final statusColors = context.statusColors;
    switch (status) {
      case PRFMissionGroundSuggestionStatus.pending:
        return statusColors.pending.main;
      case PRFMissionGroundSuggestionStatus.initiatedContact:
        return statusColors.initiated.main;
      case PRFMissionGroundSuggestionStatus.visitScheduled:
        return statusColors.scheduled.main;
      case PRFMissionGroundSuggestionStatus.missionScheduled:
        return context.prfColors.purple;
      case PRFMissionGroundSuggestionStatus.completed:
        return statusColors.completed.main;
      case PRFMissionGroundSuggestionStatus.ignore:
        return statusColors.ignored.main;
    }
  }

  IconData _getStatusIcon(PRFMissionGroundSuggestionStatus status) {
    switch (status) {
      case PRFMissionGroundSuggestionStatus.pending:
        return Icons.schedule_rounded;
      case PRFMissionGroundSuggestionStatus.initiatedContact:
        return Icons.phone_rounded;
      case PRFMissionGroundSuggestionStatus.visitScheduled:
        return Icons.calendar_today_rounded;
      case PRFMissionGroundSuggestionStatus.missionScheduled:
        return Icons.event_rounded;
      case PRFMissionGroundSuggestionStatus.completed:
        return Icons.check_circle_rounded;
      case PRFMissionGroundSuggestionStatus.ignore:
        return Icons.block_rounded;
    }
  }
}
