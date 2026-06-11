import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/helpers/permission_helper.dart';
import 'package:app/utils/helpers/url_helper.dart';
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

    final canCall = PermissionHelper.userCan(
      'edit mission ground suggestion',
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Text(
                    missionGroundSuggestion.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (canCall && missionGroundSuggestion.contactNumber.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final uri = Uri(
                          scheme: 'tel',
                          path: missionGroundSuggestion.contactNumber,
                        );
                        await UrlHelper.openUrl(uri);
                      },
                      icon: Icon(
                        Icons.call_rounded,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                  ).animate().shake(
                    duration: const Duration(seconds: 2),
                    delay: PRFMotionTokens.enterShort,
                  ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            Text(
              missionGroundSuggestion.contactPerson,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            if ((missionGroundSuggestion.notes ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                missionGroundSuggestion.notes!.trim(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: PRFSpacingTokens.md),
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
                          fontWeight: FontWeight.w600,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
