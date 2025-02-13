import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissionsPageHandset extends StatefulWidget {
  const MissionsPageHandset({super.key});

  @override
  State<MissionsPageHandset> createState() => _MissionsPageHandsetState();
}

class _MissionsPageHandsetState extends State<MissionsPageHandset> {
  @override
  void initState() {
    context.read<GetMissionsCubit>().getMissions();
    context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions();
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
            l10n.missions,
            style: PRFText.theme().displayLarge?.copyWith(fontSize: 80.sp),
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
              onPressed: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            dividerColor: Colors.white,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: PRFText.theme().displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PRFApp.theme().kPrimaryColorV2,
                ),
            indicatorColor: Colors.white,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: [
              Tab(text: l10n.all),
              Tab(text: l10n.subscribed),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<GetMissionsCubit, GetMissionsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    loaded: (missions) {
                      if (missions.isEmpty) {
                        return RefreshIndicator(
                          onRefresh: () =>
                              context.read<GetMissionsCubit>().getMissions(),
                          child: Column(
                            children: [
                              const Spacer(),
                              const Icon(
                                Icons.directions_walk,
                              ),
                              Center(
                                child: Text(
                                  l10n.noMissions,
                                  style: PRFText.theme()
                                      .headlineMedium!
                                      .copyWith(
                                        color: PRFApp.theme().kDullGreyColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      l10n.pleaseWait,
                                      style: PRFText.theme()
                                          .displayLarge!
                                          .copyWith(
                                            color:
                                                PRFApp.theme().kPrimaryColorV2,
                                            fontSize: 14,
                                          ),
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
                        onRefresh: () =>
                            context.read<GetMissionsCubit>().getMissions(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: missions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) => MissionActionCard(
                            mission: missions[index],
                            onTap: () => context.router.push(
                              MissionsDetailsRoute(
                                mission: missions[index],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<GetMemberMissionSubscriptionsCubit,
                  GetMemberMissionSubscriptionsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    loaded: (missions) {
                      if (missions.isEmpty) {
                        return RefreshIndicator(
                          onRefresh: () => context
                              .read<GetMemberMissionSubscriptionsCubit>()
                              .getSubscriptions(),
                          child: Column(
                            children: [
                              const Spacer(),
                              const Icon(Icons.directions_walk),
                              Center(
                                child: Text(
                                  l10n.noMissions,
                                  style: PRFText.theme()
                                      .headlineMedium!
                                      .copyWith(
                                        color: PRFApp.theme().kDullGreyColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      l10n.pleaseWait,
                                      style: PRFText.theme()
                                          .displayLarge!
                                          .copyWith(
                                            color:
                                                PRFApp.theme().kPrimaryColorV2,
                                            fontSize: 14,
                                          ),
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
                        onRefresh: () =>
                            context.read<GetMissionsCubit>().getMissions(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: missions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final mission = missions[index].mission;
                            return MissionActionCard(
                              mission: mission!,
                              status: missions[index].status,
                              onTap: () => context.router.push(
                                MissionsDetailsRoute(
                                  mission: missions[index].mission!,
                                ),
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

class MissionActionCard extends StatelessWidget {
  const MissionActionCard({
    required this.mission,
    this.status,
    this.onTap,
    super.key,
  });

  final PRFMission mission;

  final PRFMissionSubscriptionStatus? status;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [
        SaturateEffect(),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: width,
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 60.h,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status != null)
                    Text(
                      status!.name,
                      style: PRFText.theme().bodySmall,
                    ),
                  Text(
                    mission.school!.name,
                    style: PRFText.theme().displayLarge?.copyWith(
                          color: PRFApp.theme().kPrimaryColorV2,
                          fontWeight: FontWeight.w600,
                        ),
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
                    mission.missionType!.name,
                    style: PRFText.theme().headlineMedium?.copyWith(
                          color: PRFApp.theme().kPrimaryColorV2,
                          fontWeight: FontWeight.w600,
                        ),
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
