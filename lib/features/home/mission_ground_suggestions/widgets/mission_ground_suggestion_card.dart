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

    return PRFDetailActionCard(
      title: missionGroundSuggestion.name,
      subtitle: missionGroundSuggestion.contactPerson,
      leading: Container(
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
      trailing: PermissionHelper.userCan('viewAny mission ground suggestion')
          ? Container(
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
            )
          : null,
      footer: Row(
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
