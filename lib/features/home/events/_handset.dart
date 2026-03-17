import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class EventsPageHandset extends StatefulWidget {
  const EventsPageHandset({super.key});

  @override
  State<EventsPageHandset> createState() => _EventsPageHandsetState();
}

class _EventsPageHandsetState extends State<EventsPageHandset>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    context.read<GetEventsCubit>().getEvents();
    context
        .read<GetMemberEventSubscriptionsCubit>()
        .getMemberEventSubscriptions();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<GetEventsCubit>().getEvents();
      } else {
        context
            .read<GetMemberEventSubscriptionsCubit>()
            .getMemberEventSubscriptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.events,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          leading: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(left: PRFSpacingTokens.sm),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
              onPressed: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
            ),
          ),
          actions: [
            BlocBuilder<GetEventsCubit, GetEventsState>(
              builder: (context, state) => state.maybeWhen(
                loading: () => const SizedBox.square(
                  dimension: 24,
                  child: PRFCircularProgressIndicator(),
                ),
                orElse: SizedBox.shrink,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.sm),
            BlocBuilder<
              GetMemberEventSubscriptionsCubit,
              GetMemberEventSubscriptionsState
            >(
              builder: (context, state) => state.maybeWhen(
                loading: () => const SizedBox.square(
                  dimension: 24,
                  child: PRFCircularProgressIndicator(),
                ),
                orElse: SizedBox.shrink,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.lg),
          ],
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.all),
              Tab(text: l10n.subscribed),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildEventsTimeline(context),
            _buildSubscribedEventsTimeline(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTimeline(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<GetEventsCubit, GetEventsState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          empty: () => RefreshIndicator(
            onRefresh: () => context.read<GetEventsCubit>().getEvents(),
            child: PRFEmptyView(
              label: l10n.noEvents,
              description: l10n.pleaseWaitOS,
            ),
          ),
          loaded: (events) {
            Logger().e(events);

            // Sort events by start date for timeline
            final sortedEvents = List<PRFEvent>.from(events)
              ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return RefreshIndicator(
              onRefresh: () => context.read<GetEventsCubit>().getEvents(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.lg,
                  vertical: PRFSpacingTokens.xl,
                ),
                itemCount: sortedEvents.length,
                itemBuilder: (context, index) {
                  final event = sortedEvents[index];
                  final isLast = index == sortedEvents.length - 1;

                  return TimelineEventCard(
                        event: event,
                        isLast: isLast,
                        index: index,
                        onTap: () => context.router.push(
                          EventDetailsRoute(event: event),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: index * 100),
                        duration: PRFMotionTokens.enterShort,
                      )
                      .slideX(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubscribedEventsTimeline(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<
      GetMemberEventSubscriptionsCubit,
      GetMemberEventSubscriptionsState
    >(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          empty: () => RefreshIndicator(
            onRefresh: () => context
                .read<GetMemberEventSubscriptionsCubit>()
                .getMemberEventSubscriptions(),
            child: PRFEmptyView(
              label: l10n.noEvents,
              description: l10n.pleaseWaitForOS,
            ),
          ),
          loaded: (eventSubscriptions) {
            Logger().e(eventSubscriptions);

            final events =
                eventSubscriptions
                    .map((subscription) => subscription.event)
                    .whereType<PRFEvent>()
                    .toList()
                  ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return RefreshIndicator(
              onRefresh: () => context
                  .read<GetMemberEventSubscriptionsCubit>()
                  .getMemberEventSubscriptions(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.lg,
                  vertical: PRFSpacingTokens.xl,
                ),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isLast = index == events.length - 1;

                  return TimelineEventCard(
                        event: event,
                        isLast: isLast,
                        index: index,
                        isSubscribed: true,
                        onTap: () => context.router.push(
                          EventDetailsRoute(event: event),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: index * 100),
                        duration: PRFMotionTokens.enterShort,
                      )
                      .slideX(
                        begin: 0.3,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            );
          },
        );
      },
    );
  }
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
        ? PRFColors.limeGreen
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
        SizedBox(
          width: 60,
          child: Column(
            children: [
              // Multi-day date badge
              Container(
                width: 50,
                height: isMultiDay ? 90 : 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMultiDay) ...[
                      // Start date
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.7),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      // End date
                      Text(
                        endDate.day.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(endDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                    ] else ...[
                      // Single day
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Timeline line with flexible height
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    vertical: PRFSpacingTokens.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        statusColor.withValues(alpha: 0.6),
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: PRFSpacingTokens.lg),

        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Premium header with gradient
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            statusColor.withValues(alpha: 0.1),
                            statusColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Event name and status
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.sm,
                                  vertical: PRFSpacingTokens.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  statusText,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PRFSpacingTokens.md),

                          // Event venue with icon
                          if (event.venue != null)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.sm,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: 16,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.sm),
                                Expanded(
                                  child: Text(
                                    event.venue!,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Event details
                    Padding(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Duration and capacity info chips
                          Row(
                            children: [
                              Flexible(
                                child: _buildInfoChip(
                                  context,
                                  Icons.schedule_rounded,
                                  'Duration',
                                  isMultiDay ? '$duration days' : 'Single day',
                                  theme.colorScheme.primaryContainer,
                                  theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Flexible(
                                child: _buildInfoChip(
                                  context,
                                  Icons.people_rounded,
                                  'Capacity',
                                  '${event.capacity} attendees',
                                  theme.colorScheme.secondaryContainer,
                                  theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Date range display
                          Container(
                            padding: const EdgeInsets.all(PRFSpacingTokens.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.smd,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: PRFSpacingTokens.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isMultiDay
                                            // ignore: lines_longer_than_80_chars
                                            ? '${DateFormatter.formatDate(startDate, timezone)} - ${DateFormatter.formatDate(endDate, timezone)}'
                                            : DateFormatter.formatDate(
                                                startDate,
                                                timezone,
                                              ),
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        // ignore: lines_longer_than_80_chars
                                        '${DateFormatter.formatTime(event.startTime, timezone)} - ${DateFormatter.formatTime(event.endTime, timezone)} daily',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Description preview
                          if (event.description.isNotEmpty)
                            Text(
                              event.description.split('\n').first,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Action button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                              vertical: PRFSpacingTokens.md,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  statusColor.withValues(alpha: 0.1),
                                  statusColor.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.smd,
                              ),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View Details',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.sm),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: statusColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color backgroundColor,
    Color textColor,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
