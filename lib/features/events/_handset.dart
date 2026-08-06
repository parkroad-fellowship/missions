import 'package:app/features/events/cubit/event_resource_cubit.dart';
import 'package:app/features/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.dart';
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
                          listLoading: (_) => const SizedBox.square(
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
                          listLoading: (_) => const SizedBox.square(
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
            child: PRFCircularProgressIndicator(
              color: theme.colorScheme.primary,
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

            return RefreshIndicator(
              onRefresh: () => context.read<EventResourceCubit>().loadAll(),
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
            child: PRFCircularProgressIndicator(
              color: theme.colorScheme.primary,
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

            final events = eventSubscriptions
                .map((subscription) => subscription.event)
                .whereType<PRFEvent>()
                .toList();

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
