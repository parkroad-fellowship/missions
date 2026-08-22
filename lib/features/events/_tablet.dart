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
            // Same source as the lists: counts and highlights never flash
            // zero mid-reload.
            final events = context.read<EventResourceCubit>().currentItems;
            final subscriptions = context
                .read<EventSubscriptionResourceCubit>()
                .currentItems;
            final isLoading =
                eventState.maybeWhen(
                  listLoading: (_) => true,
                  orElse: () => false,
                ) ||
                subscriptionState.maybeWhen(
                  listLoading: (_) => true,
                  orElse: () => false,
                );

            return PRFTabletSplitScaffold(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PRFTabletHeaderRow(
                    title: l10n.events,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.landingRoute,
                    ),
                    isLoading: isLoading,
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
                        dividerColor: theme.colorScheme.outline.withValues(
                          alpha: 0.12,
                        ),
                        labelStyle: theme.textTheme.titleSmall?.copyWith(
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
              sidePanel: PRFBrandPanel(
                children: [
                  PRFPanelSectionLabel(l10n.fellowshipEvents),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.eventsPanelIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: PRFColors.navy100,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _EventStatChip(
                          label: l10n.availableCount(events.length),
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      Expanded(
                        child: _EventStatChip(
                          label: l10n.subscribedCount(subscriptions.length),
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  Center(
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: PRFOpacities.half),
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    l10n.participateLearn,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  Text(
                    l10n.eventsPanelBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: PRFColors.navy100,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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

    // Same source as the list: pull-to-refresh keeps cards visible instead
    // of flashing a full-screen spinner.
    final events = context.read<EventResourceCubit>().currentItems;

    final showInitialLoader =
        state is ResourceListLoading<PRFEvent> && events.isEmpty;

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
        child: PRFEmptyView(
          label: l10n.noEvents,
          description: message,
          icon: Icons.error_outline_rounded,
        ),
      );
    }

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
                curve: PRFMotionTokens.entering,
              );
        },
      ),
    );
  }

  Widget _buildSubscribedEventsTimeline(
    BuildContext context,
    ResourceState<PRFEventSubscription> state,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // Same source as the list: pull-to-refresh keeps cards visible instead
    // of flashing a full-screen spinner.
    final subscriptions = context
        .read<EventSubscriptionResourceCubit>()
        .currentItems;

    final events = subscriptions
        .map((subscription) => subscription.event)
        .whereType<PRFEvent>()
        .toList();

    final showInitialLoader =
        state is ResourceListLoading<PRFEventSubscription> && events.isEmpty;

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
        child: PRFEmptyView(
          label: l10n.noEvents,
          description: message,
          icon: Icons.error_outline_rounded,
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
      onRefresh: () => context.read<EventSubscriptionResourceCubit>().loadAll(),
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
                curve: PRFMotionTokens.entering,
              );
        },
      ),
    );
  }
}

class _EventStatChip extends StatelessWidget {
  const _EventStatChip({required this.label, this.highlight = false});

  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.sm),
      decoration: BoxDecoration(
        color: highlight
            ? PRFColors.limeGreen
            : Colors.white.withValues(alpha: PRFOpacities.hairline),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: highlight ? PRFColors.navyBlue : Colors.white,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
