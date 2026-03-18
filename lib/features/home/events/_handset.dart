import 'package:app/features/home/events/cubit/event_resource_cubit.dart';
import 'package:app/features/home/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

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

    context.read<EventResourceCubit>().loadAll();
    context.read<EventSubscriptionResourceCubit>().loadAll();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<EventResourceCubit>().loadAll();
      } else {
        context.read<EventSubscriptionResourceCubit>().loadAll();
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
        backgroundColor: theme.colorScheme.surface,
        body: Column(
          children: [
            ColoredBox(
              color: theme.colorScheme.primary,
              child: Column(
                children: [
                  PRFBrandedNavBar(
                    title: l10n.events,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.landingRoute,
                    ),
                    actions: [
                      BlocBuilder<EventResourceCubit, ResourceState<PRFEvent>>(
                        builder: (context, state) => state.maybeWhen(
                          listLoading: () => const SizedBox.square(
                            dimension: 24,
                            child: PRFCircularProgressIndicator(),
                          ),
                          orElse: SizedBox.shrink,
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      BlocBuilder<
                        EventSubscriptionResourceCubit,
                        ResourceState<PRFEventSubscription>
                      >(
                        builder: (context, state) => state.maybeWhen(
                          listLoading: () => const SizedBox.square(
                            dimension: 24,
                            child: PRFCircularProgressIndicator(),
                          ),
                          orElse: SizedBox.shrink,
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.lg),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      PRFSpacingTokens.lg,
                      0,
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.sm,
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, -6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: theme.colorScheme.onPrimary,
                          unselectedLabelColor: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.65),
                          indicatorColor: theme.colorScheme.secondary,
                          dividerColor: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          labelStyle: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.sm,
                          ),
                          tabs: [
                            Tab(text: l10n.all),
                            Tab(text: l10n.subscribed),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEventsTimeline(context),
                  _buildSubscribedEventsTimeline(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTimeline(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<EventResourceCubit, ResourceState<PRFEvent>>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          error: (message, _) => Center(
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
          listLoaded: (events, _, _) {
            if (events.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<EventResourceCubit>().loadAll(),
                child: PRFEmptyView(
                  label: l10n.noEvents,
                  description: l10n.pleaseWaitOS,
                ),
              );
            }
            Logger().e(events);

            // Sort events by start date for timeline
            final sortedEvents = List<PRFEvent>.from(events)
              ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return RefreshIndicator(
              onRefresh: () => context.read<EventResourceCubit>().loadAll(),
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
      EventSubscriptionResourceCubit,
      ResourceState<PRFEventSubscription>
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
          error: (message, _) => Center(
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
          listLoaded: (eventSubscriptions, _, _) {
            if (eventSubscriptions.isEmpty) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<EventSubscriptionResourceCubit>().loadAll(),
                child: PRFEmptyView(
                  label: l10n.noEvents,
                  description: l10n.pleaseWaitForOS,
                ),
              );
            }
            Logger().e(eventSubscriptions);

            final events =
                eventSubscriptions
                    .map((subscription) => subscription.event)
                    .whereType<PRFEvent>()
                    .toList()
                  ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<EventSubscriptionResourceCubit>().loadAll(),
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
                    label: 'Venue',
                    value: event.venue!,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        context,
                        Icons.schedule_rounded,
                        'Duration',
                        isMultiDay ? '$duration days' : 'Single day',
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    Expanded(
                      child: _buildInfoChip(
                        context,
                        Icons.people_rounded,
                        'Capacity',
                        '${event.capacity} attendees',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                PRFInfoCard(
                  icon: Icons.calendar_today_rounded,
                  label: isMultiDay ? 'Date Range' : 'Date',
                  value: isMultiDay
                      ? '${DateFormatter.formatDate(startDate, timezone)} - '
                            '${DateFormatter.formatDate(endDate, timezone)}'
                      : DateFormatter.formatDate(startDate, timezone),
                ),
                const SizedBox(height: PRFSpacingTokens.sm),
                PRFInfoCard(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
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

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return PRFInfoCard(
      icon: icon,
      label: label,
      value: value,
    );
  }
}
