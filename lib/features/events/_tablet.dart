import 'package:app/features/events/_shared.dart';
import 'package:app/features/events/cubit/event_resource_cubit.dart';
import 'package:app/features/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class EventsPageTablet extends StatefulWidget {
  const EventsPageTablet({super.key});

  @override
  State<EventsPageTablet> createState() => _EventsPageTabletState();
}

class _EventsPageTabletState extends State<EventsPageTablet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _form = EventsFormState();

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

    _form.attach(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<EventResourceCubit, ResourceState<PRFEvent>>(
      builder: (context, eventState) {
        return BlocBuilder<
          EventSubscriptionResourceCubit,
          ResourceState<PRFEventSubscription>
        >(
          builder: (context, subscriptionState) {
            final events = eventState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFEvent>.empty,
            );
            final subscriptions = subscriptionState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFEventSubscription>.empty,
            );

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Column - Timeline and Tabs (flex: 3)
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.lg,
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () => context.router
                                            .popUntilRouteWithPath(
                                              PRFSuperAppRouter.landingRoute,
                                            ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.xs,
                                      ),
                                      Expanded(
                                        child: Text(
                                          l10n.events,
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                      // Progress indicators
                                      if (eventState.maybeWhen(
                                            listLoading: (_) => true,
                                            orElse: () => false,
                                          ) ||
                                          subscriptionState.maybeWhen(
                                            listLoading: (_) => true,
                                            orElse: () => false,
                                          ))
                                        const SizedBox.square(
                                          dimension: 24,
                                          child: PRFCircularProgressIndicator(),
                                        ),
                                    ],
                                  ),
                                ),

                                // Custom Widescreen TabBar
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.xl,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TabBar(
                                      controller: _tabController,
                                      isScrollable: true,
                                      labelColor: theme.colorScheme.primary,
                                      unselectedLabelColor:
                                          theme.colorScheme.onSurfaceVariant,
                                      indicatorColor: theme.colorScheme.primary,
                                      dividerColor: theme.colorScheme.outline
                                          .withValues(alpha: 0.12),
                                      labelStyle: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                      tabs: [
                                        Tab(text: l10n.all),
                                        Tab(text: l10n.subscribed),
                                      ],
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildEventsTimeline(context, eventState),
                                      _buildSubscribedEventsTimeline(
                                        context,
                                        subscriptionState,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical Divider
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),

                          // Right Column - Event Summary Panel & Guide (flex: 2)
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.lg,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fellowship Events',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.xl),

                                  // Event stats card
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(
                                      PRFSpacingTokens.xl,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.md,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Join fellowship gatherings, teachings, conferences and local spiritual events.',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                height: 1.4,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: PRFSpacingTokens.lg,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  PRFSpacingTokens.sm,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        PRFRadiusTokens.md,
                                                      ),
                                                ),
                                                child: Text(
                                                  '${events.length} Available',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: PRFSpacingTokens.sm,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  PRFSpacingTokens.sm,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .prfColors
                                                      .limeGreen
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        PRFRadiusTokens.md,
                                                      ),
                                                ),
                                                child: Text(
                                                  '${subscriptions.length} Subscribed',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: context
                                                            .prfColors
                                                            .limeGreen,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Helpful guidelines
                                  Center(
                                    child: Icon(
                                      Icons.calendar_month_outlined,
                                      size: 64,
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.md),
                                  Text(
                                    'Participate & Learn',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.sm),
                                  Text(
                                    'Tap any event from the left list to subscribe and secure your slot, view attendees lists, and read schedules and timelines.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEventsTimeline(
    BuildContext context,
    ResourceState<PRFEvent> state,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return state.maybeWhen(
      orElse: () => Center(
        child: PRFCircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
      error: (message, _) => Center(
        child: PRFEmptyView(
          label: l10n.noEvents,
          description: message,
          icon: Icons.error_outline_rounded,
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

        return RefreshIndicator(
          onRefresh: () => context.read<EventResourceCubit>().loadAll(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
  }

  Widget _buildSubscribedEventsTimeline(
    BuildContext context,
    ResourceState<PRFEventSubscription> state,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return state.maybeWhen(
      orElse: () => Center(
        child: PRFCircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
      error: (message, _) => Center(
        child: PRFEmptyView(
          label: l10n.noEvents,
          description: message,
          icon: Icons.error_outline_rounded,
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

        final events = eventSubscriptions
            .map((subscription) => subscription.event)
            .whereType<PRFEvent>()
            .toList();

        return RefreshIndicator(
          onRefresh: () =>
              context.read<EventSubscriptionResourceCubit>().loadAll(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
  }
}
