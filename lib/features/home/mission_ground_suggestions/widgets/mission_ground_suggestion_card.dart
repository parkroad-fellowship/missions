import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
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
                      missionGroundSuggestion.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                    borderRadius: BorderRadius.circular(12),
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
                      delay: Duration(milliseconds: 500),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Status and additional info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme, missionGroundSuggestion.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(missionGroundSuggestion.status),
                      size: 14,
                      color: _getStatusTextColor(
                        theme,
                        missionGroundSuggestion.status,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      missionGroundSuggestion.status.name.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusTextColor(
                          theme,
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
    ThemeData theme,
    PRFMissionGroundSuggestionStatus status,
  ) {
    switch (status) {
      case PRFMissionGroundSuggestionStatus.pending:
        return theme.colorScheme.secondaryContainer;
      case PRFMissionGroundSuggestionStatus.initiatedContact:
        return Colors.blue.withValues(alpha: 0.2);
      case PRFMissionGroundSuggestionStatus.visitScheduled:
        return Colors.orange.withValues(alpha: 0.2);
      case PRFMissionGroundSuggestionStatus.missionScheduled:
        return Colors.purple.withValues(alpha: 0.2);
      case PRFMissionGroundSuggestionStatus.completed:
        return Colors.green.withValues(alpha: 0.2);
      case PRFMissionGroundSuggestionStatus.ignore:
        return Colors.red.withValues(alpha: 0.2);
    }
  }

  Color _getStatusTextColor(
    ThemeData theme,
    PRFMissionGroundSuggestionStatus status,
  ) {
    switch (status) {
      case PRFMissionGroundSuggestionStatus.pending:
        return theme.colorScheme.onSecondaryContainer;
      case PRFMissionGroundSuggestionStatus.initiatedContact:
        return Colors.blue.shade700;
      case PRFMissionGroundSuggestionStatus.visitScheduled:
        return Colors.orange.shade700;
      case PRFMissionGroundSuggestionStatus.missionScheduled:
        return Colors.purple.shade700;
      case PRFMissionGroundSuggestionStatus.completed:
        return Colors.green.shade700;
      case PRFMissionGroundSuggestionStatus.ignore:
        return Colors.red.shade700;
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
