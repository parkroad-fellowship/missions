import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/events/event_details/add_event_subscription/add_event_subscription.dart';
import 'package:app/features/home/events/event_details/add_media/add_media.dart';
import 'package:app/features/home/events/event_details/event_details/event_details.dart';
import 'package:app/features/home/events/event_details/gallery/gallery.dart';
import 'package:app/features/home/events/event_details/update_event_subscription/update_event_subscription.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

    return Scaffold(
      body: DefaultTabController(
        length: tabCount,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomScrollView(
              slivers: [
                // Start Navigation Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1.w,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            padding: const EdgeInsets.only(left: 8),
                            onPressed:
                                () => context.router.popUntilRouteWithPath(
                                  PRFSuperAppRouter.eventsRoute,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.eventDetails,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const Spacer(),
                        // Show an icon with the number of tickets
                        if (event.loggedInMemberEventSubscription != null)
                          Row(
                            spacing: 4,
                            children: [
                              Text(
                                event
                                    .loggedInMemberEventSubscription!
                                    .numberOfAttendees
                                    .toString(),
                                style: Theme.of(context).textTheme.displayMedium!,
                              ),
                              const Icon(Icons.group),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                // End Navigation Bar
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: _tabController,
                    onTap:
                        (value) => setState(() {
                          Logger().d(value);
                          _currentTab = value;
                        }),
                    dividerColor: Colors.white,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle: Theme.of(context).textTheme.displayMedium!,
                    indicatorColor: Colors.white,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: [Tab(text: l10n.info), Tab(text: l10n.gallery)],
                  ),
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        EventDetailsView(event: event),
                        EventGalleryView(eventUlid: event.ulid),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: switch (_currentTab) {
        0 => FloatingActionButton(
          onPressed: () {
            if (event.loggedInMemberEventSubscription == null) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddEventSubscriptionView(event: event),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                // ignore: use_build_context_synchronously
                context.read<GetEventsCubit>().getEvents();
              });
            }

            if (event.loggedInMemberEventSubscription != null) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: UpdateEventSubscriptionView(event: event),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                // ignore: use_build_context_synchronously
                context
                    .read<GetMemberEventSubscriptionsCubit>()
                    .getMemberEventSubscriptions();
              });
            }
          },
          child: Icon(
            event.loggedInMemberEventSubscription == null
                ? Icons.add
                : Icons.edit,
            color: Colors.white,
          ),
        ),
        1 => FloatingActionButton(
          onPressed: () {
            if (_currentTab == 1) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddEventMediaView(eventUlid: event.ulid),
                      ),
                    ),
                  ];
                },
              );
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        _ => null,
      },
    );
  }
}
