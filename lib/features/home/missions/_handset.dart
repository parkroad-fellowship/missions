import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_mission.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class MissionsPageHandset extends StatefulWidget {
  const MissionsPageHandset({super.key});

  @override
  State<MissionsPageHandset> createState() => _MissionsPageHandsetState();
}

class _MissionsPageHandsetState extends State<MissionsPageHandset>
    with SingleTickerProviderStateMixin {
  Stream<List<PRFLocalMission>> get _missionsStream =>
      getIt<LocalDBService>().missions;

  Stream<List<PRFLocalMission>> get _memberMissionsStream =>
      getIt<LocalDBService>().memberMissions;

  @override
  void initState() {
    super.initState();

    context.read<GetMissionsCubit>().getMissions(refresh: true);
    context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions(
      refresh: true,
    );

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<GetMissionsCubit>().getMissions();
      } else {
        context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions();
      }
    });
  }

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.missions,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: PRFApp.theme().kPrimaryColorV2,
                width: 1.w,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              padding: const EdgeInsets.only(left: 16, right: 8),
              onPressed:
                  () => context.router.popUntilRouteWithPath(
                    PRFSuperAppRouter.landingRoute,
                  ),
            ),
          ),
          actions: [
            BlocBuilder<GetMissionsCubit, GetMissionsState>(
              builder:
                  (context, state) => state.maybeWhen(
                    loading:
                        () => const SizedBox.square(
                          dimension: 24,
                          child: PRFCircularProgressIndicator(),
                        ),
                    orElse: SizedBox.shrink,
                  ),
            ),
            const SizedBox(width: 8),

            BlocBuilder<
              GetMemberMissionSubscriptionsCubit,
              GetMemberMissionSubscriptionsState
            >(
              builder:
                  (context, state) => state.maybeWhen(
                    loading:
                        () => const SizedBox.square(
                          dimension: 24,
                          child: PRFCircularProgressIndicator(),
                        ),
                    orElse: SizedBox.shrink,
                  ),
            ),
            const SizedBox(width: 16),
          ],
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            dividerColor: Colors.white,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: Theme.of(context).textTheme.displayMedium!,
            indicatorColor: Colors.white,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: [Tab(text: l10n.all), Tab(text: l10n.subscribed)],
          ),
        ),
        body: TabBarView(
          controller: _tabController,

          children: [
            StreamBuilder<List<PRFLocalMission>>(
              key: PageStorageKey('missions_stream_${_tabController.index}'),
              initialData: const [],
              stream: _missionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const PRFCircularProgressIndicator();
                }

                final missions = snapshot.data;

                Logger().e(missions);

                if (missions != null && missions.isEmpty) {
                  return RefreshIndicator(
                    onRefresh:
                        () => context.read<GetMissionsCubit>().getMissions(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(Icons.directions_walk),
                        Center(
                          child: Text(
                            l10n.noMissions,
                            style: Theme.of(context).textTheme.headlineMedium!,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: Theme.of(context).textTheme.displayLarge!,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh:
                      () => context.read<GetMissionsCubit>().getMissions(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: missions!.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: 16.h),
                    itemBuilder:
                        (context, index) => MissionActionCard(
                          mission: missions[index],
                          onTap:
                              () => context.router.push(
                                MissionsDetailsRoute(
                                  missionUlid: missions[index].ulid,
                                ),
                              ),
                        ),
                  ),
                );
              },
            ),

            StreamBuilder<List<PRFLocalMission>>(
              key: PageStorageKey('missions_stream_${_tabController.index}'),
              initialData: const [],
              stream: _memberMissionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const PRFCircularProgressIndicator();
                }

                final missions = snapshot.data;

                Logger().e(missions);

                if (missions != null && missions.isEmpty) {
                  return RefreshIndicator(
                    onRefresh:
                        () =>
                            context
                                .read<GetMemberMissionSubscriptionsCubit>()
                                .getSubscriptions(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(Icons.directions_walk),
                        Center(
                          child: Text(
                            l10n.noMissions,
                            style: Theme.of(context).textTheme.headlineMedium!,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: Theme.of(context).textTheme.displayLarge!,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh:
                      () =>
                          context
                              .read<GetMemberMissionSubscriptionsCubit>()
                              .getSubscriptions(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: missions!.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      return MissionActionCard(
                        mission: mission,
                        status:
                            mission.loggedInMemberMissionSubscription!.status,
                        onTap:
                            () => context.router.push(
                              MissionsDetailsRoute(
                                missionUlid: missions[index].ulid,
                              ),
                            ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MissionActionCard extends StatelessWidget {
  const MissionActionCard({
    required this.mission,
    this.status,
    this.onTap,
    super.key,
  });

  final PRFLocalMission mission;

  final PRFMissionSubscriptionStatus? status;
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
                color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status != null)
                    Text(status!.name, style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    mission.school!.name!,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.missionStart(
                      Misc.formatDate(mission.startDate),
                      Misc.formatTime(mission.startTime),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    mission.missionType!.name!,
                    style: Theme.of(context).textTheme.headlineMedium,
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
