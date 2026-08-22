import 'package:app/features/events/_shared.dart';
import 'package:app/features/events/cubit/event_resource_cubit.dart';
import 'package:app/features/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/features/missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class EventsPageHandset extends StatefulWidget {
  const EventsPageHandset({super.key});

  @override
  State<EventsPageHandset> createState() => _EventsPageHandsetState();
}

class _EventsPageHandsetState extends State<EventsPageHandset>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _form = EventsFormState();

  // The entrance cascade plays exactly once per screen instance; stored on
  // the state so helper build methods can gate their timelines too.
  bool _entrancePlayed = false;
  late bool _animateEntrance;

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
    _animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

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
        // Same source as the list: pull-to-refresh keeps cards visible
        // instead of flashing a full-screen spinner.
        final currentEvents =
            context.read<EventResourceCubit>().currentItems;

        final showInitialLoader =
            state is ResourceListLoading<PRFEvent> && currentEvents.isEmpty;

        if (showInitialLoader) {
          return Center(
            child: PRFCircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (state.maybeWhen(
          error: (_, _) => true,
          itemError: (_, _, _) => true,
          orElse: () => false,
        )) {
          final message = state.maybeWhen(
            error: (message, _) => message,
            itemError: (message, _, _) => message,
            orElse: () => '',
          );
          return Center(
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
          );
        }

        if (currentEvents.isEmpty) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.xl,
            ),
            itemCount: currentEvents.length,
            itemBuilder: (context, index) {
              final event = currentEvents[index];
              final isLast = index == currentEvents.length - 1;

              return buildAnimatedTimelineEntry(
                context: context,
                index: index,
                animate: _animateEntrance,
                child: TimelineEventCard(
                  event: event,
                  isLast: isLast,
                  index: index,
                  onTap: () => context.router.push(
                    EventDetailsRoute(event: event),
                  ),
                ),
              );
            },
          ),
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
        // Same source as the list: pull-to-refresh keeps cards visible
        // instead of flashing a full-screen spinner.
        final subscriptions = context
            .read<EventSubscriptionResourceCubit>()
            .currentItems;
        final events = subscriptions
            .map((subscription) => subscription.event)
            .whereType<PRFEvent>()
            .toList();

        final showInitialLoader =
            state is ResourceListLoading<PRFEventSubscription> &&
            events.isEmpty;

        if (showInitialLoader) {
          return Center(
            child: PRFCircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (state.maybeWhen(
          error: (_, _) => true,
          itemError: (_, _, _) => true,
          orElse: () => false,
        )) {
          final message = state.maybeWhen(
            error: (message, _) => message,
            itemError: (message, _, _) => message,
            orElse: () => '',
          );
          return Center(
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
          );
        }

        if (events.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<EventSubscriptionResourceCubit>().loadAll(),
            child: PRFEmptyView(
              label: l10n.noEvents,
              description: l10n.pleaseWaitForOS,
            ),
          );
        }

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

              return buildAnimatedTimelineEntry(
                context: context,
                index: index,
                animate: _animateEntrance,
                child: TimelineEventCard(
                  event: event,
                  isLast: isLast,
                  index: index,
                  isSubscribed: true,
                  onTap: () => context.router.push(
                    EventDetailsRoute(event: event),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
