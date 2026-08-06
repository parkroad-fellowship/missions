import 'package:app/features/events/cubit/event_resource_cubit.dart';
import 'package:app/features/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/features/events/event_details/actions/add_event_subscription/add_event_subscription.dart';
import 'package:app/features/events/event_details/actions/add_media/add_media.dart';
import 'package:app/features/events/event_details/actions/update_event_subscription/update_event_subscription.dart';
import 'package:app/features/events/event_details/event_details/event_details.dart';
import 'package:app/features/events/event_details/gallery/gallery.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

class EventDetailsPageHandset extends StatefulWidget {
  const EventDetailsPageHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<EventDetailsPageHandset> createState() =>
      _EventDetailsPageHandsetState();
}

class _EventDetailsPageHandsetState extends State<EventDetailsPageHandset>
    with SingleTickerProviderStateMixin {
  PRFEvent get event => widget.event;

  int tabCount = 2;

  late TabController _tabController;
  int _currentTab = 0;

  void _changeTab() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: tabCount, vsync: this);
    _tabController.addListener(_changeTab);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_changeTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: DefaultTabController(
        length: tabCount,
        child: Column(
          children: [
            ColoredBox(
              color: theme.colorScheme.primary,
              child: Column(
                children: [
                  PRFBrandedNavBar(
                    title: l10n.eventDetails,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.eventsRoute,
                    ),
                    actions: [
                      if (event.loggedInMemberEventSubscription != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.md,
                            vertical: PRFSpacingTokens.xs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            l10n.areGoing(
                              event
                                  .loggedInMemberEventSubscription!
                                  .numberOfAttendees,
                            ),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
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
                          onTap: (value) => setState(() {
                            Logger().d(value);
                            _currentTab = value;
                          }),
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
                            Tab(text: l10n.info),
                            Tab(text: l10n.gallery),
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
                  EventDetailsView(event: event),
                  EventGalleryView(eventUlid: event.ulid),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: switch (_currentTab) {
        0 => FloatingActionButton(
          onPressed: () {
            if (event.loggedInMemberEventSubscription == null) {
              PRFBottomSheet.show<void>(
                context,
                title: context.l10n.subscribe,
                child: AddEventSubscriptionView(event: event),
              ).then((_) {
                // ignore: use_build_context_synchronously
                context.read<EventResourceCubit>().loadAll();
              });
            }

            if (event.loggedInMemberEventSubscription != null) {
              PRFBottomSheet.show<void>(
                context,
                title: context.l10n.updateSubscription,
                child: UpdateEventSubscriptionView(event: event),
              ).then((_) {
                // ignore: use_build_context_synchronously
                context.read<EventSubscriptionResourceCubit>().loadAll();
              });
            }
          },
          child: Icon(
            event.loggedInMemberEventSubscription == null
                ? Icons.add
                : Icons.edit,
            color: PRFColors.white,
          ),
        ),
        1 => FloatingActionButton(
          onPressed: () {
            if (_currentTab == 1) {
              PRFBottomSheet.show<void>(
                context,
                title: context.l10n.addMedia,
                child: AddEventMediaView(eventUlid: event.ulid),
              );
            }
          },
          child: const Icon(Icons.add, color: PRFColors.white),
        ),
        _ => null,
      },
    );
  }
}
