import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventsPageHandset extends StatefulWidget {
  const EventsPageHandset({super.key});

  @override
  State<EventsPageHandset> createState() => _EventsPageHandsetState();
}

class _EventsPageHandsetState extends State<EventsPageHandset> {
  @override
  void initState() {
    context.read<GetEventsCubit>().getEvents();
    context
        .read<GetMemberEventSubscriptionsCubit>()
        .getMemberEventSubscriptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.events,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1.w),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              onPressed:
                  () => context.router.popUntilRouteWithPath(
                    PRFSuperAppRouter.landingRoute,
                  ),
            ),
          ),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            isScrollable: true,
            tabs: [Tab(text: l10n.all), Tab(text: l10n.subscribed)],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<GetEventsCubit, GetEventsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    empty:
                        () => RefreshIndicator(
                          onRefresh:
                              () => context.read<GetEventsCubit>().getEvents(),
                          child: PRFEmptyView(
                            label: l10n.noEvents,
                            description: l10n.pleaseWaitOS,
                          ),
                        ),
                    loaded:
                        (events) => RefreshIndicator(
                          onRefresh:
                              () => context.read<GetEventsCubit>().getEvents(),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: events.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 16.h),
                            itemBuilder:
                                (context, index) => EventActionCard(
                                  event: events[index],
                                  onTap:
                                      () => context.router.push(
                                        EventDetailsRoute(event: events[index]),
                                      ),
                                ),
                          ),
                        ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<
                GetMemberEventSubscriptionsCubit,
                GetMemberEventSubscriptionsState
              >(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    empty:
                        () => RefreshIndicator(
                          onRefresh:
                              () =>
                                  context
                                      .read<
                                        GetMemberMissionSubscriptionsCubit
                                      >()
                                      .getSubscriptions(),
                          child: PRFEmptyView(
                            label: l10n.noEvents,
                            description: l10n.pleaseWaitForOS,
                          ),
                        ),
                    loaded: (events) {
                      return RefreshIndicator(
                        onRefresh:
                            () => context.read<GetEventsCubit>().getEvents(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: events.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final event = events[index].event;
                            return EventActionCard(
                              event: event!,
                              onTap:
                                  () => context.router.push(
                                    EventDetailsRoute(event: event),
                                  ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventActionCard extends StatelessWidget {
  const EventActionCard({required this.event, this.onTap, super.key});

  final PRFEvent event;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.missionStart(
                      Misc.formatDate(event.startDate),
                      Misc.formatTime(event.startTime),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    event.description.split('\n').first,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
