import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class EventsFormState {
  EventsFormState();

  late final VoidCallback _rebuild;

  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
    // ignore: unnecessary_null_comparison
    if (_rebuild != null) {
      _rebuild();
    }
  }

  void dispose() {}
}

class TimelineEventCard extends StatelessWidget with TimezoneMixin {
  const TimelineEventCard({
    required this.event,
    required this.isLast,
    required this.index,
    this.isSubscribed = false,
    this.onTap,
    super.key,
  });

  final PRFEvent event;
  final bool isLast;
  final int index;
  final bool isSubscribed;
  final VoidCallback? onTap;

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final startDate = event.startDate;
    final endDate = event.endDate;
    final isUpcoming = startDate.isAfter(now);
    final isPast = endDate.isBefore(now.subtract(const Duration(days: 1)));
    final isOngoing = startDate.isBefore(now) && endDate.isAfter(now);
    final isMultiDay = !_isSameDay(startDate, endDate);
    final duration = endDate.difference(startDate).inDays + 1;

    // Premium status color system
    final statusColor = isSubscribed
        ? context.prfColors.limeGreen
        : isOngoing
        ? PRFColors
              .limeGreen // Active green
        : isUpcoming
        ? theme.colorScheme.primary
        : isPast
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.secondary;

    final statusText = isSubscribed
        ? 'Subscribed'
        : isOngoing
        ? 'Active'
        : isUpcoming
        ? 'Upcoming'
        : isPast
        ? 'Completed'
        : 'Available';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PRFTimelineDateBadge(
          startDate: startDate,
          endDate: isMultiDay ? endDate : null,
          statusColor: statusColor,
          isLast: isLast,
        ),
        const SizedBox(width: PRFSpacingTokens.lg),
        Expanded(
          child: PRFDetailActionCard(
            onTap: onTap,
            margin: EdgeInsets.only(bottom: isLast ? 0 : PRFSpacingTokens.lg),
            backgroundColor: theme.colorScheme.surface,
            title: event.name,
            subtitle: event.description.isNotEmpty
                ? event.description.split('\n').first
                : 'Tap to view event details',
            trailing: PRFStatusBadge(
              label: statusText,
              color: statusColor,
            ),
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.venue != null) ...[
                  PRFInfoCard(
                    icon: Icons.location_on_rounded,
                    label: context.l10n.venue,
                    value: event.venue!,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                ],
                Row(
                  children: [
                    Expanded(
                      child: PRFInfoCard(
                        icon: Icons.schedule_rounded,
                        label: 'Duration',
                        value: isMultiDay ? '$duration days' : 'Single day',
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: PRFInfoCard(
                        icon: Icons.people_rounded,
                        label: 'Capacity',
                        value: '${event.capacity} attendees',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                PRFInfoCard(
                  icon: Icons.calendar_today_rounded,
                  label: isMultiDay
                      ? context.l10n.dateRange
                      : context.l10n.date,
                  value: isMultiDay
                      ? '${DateFormatter.formatDate(startDate, timezone)} - '
                            '${DateFormatter.formatDate(endDate, timezone)}'
                      : DateFormatter.formatDate(startDate, timezone),
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                PRFInfoCard(
                  icon: Icons.access_time_rounded,
                  label: context.l10n.time_2,
                  value:
                      '${DateFormatter.formatTime(event.startTime, timezone)} '
                      '- ${DateFormatter.formatTime(event.endTime, timezone)} '
                      'daily',
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View Details',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.xs),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: statusColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
