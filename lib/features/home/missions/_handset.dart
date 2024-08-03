import 'package:app/enums/prf_mission_status.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_past_member_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    context.read<GetMemberMissionSubscriptionsCubit>().getUpcomingMissions();
    context.read<GetPastMemberMissionsCubit>().getPastMissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.missions,
            style: CustomTextTheme.customTextTheme()
                .displayLarge
                ?.copyWith(fontSize: 80.sp),
          ),
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.appTheme().kPrimaryColorV2,
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
            labelStyle:
                CustomTextTheme.customTextTheme().displayLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppTheme.appTheme().kPrimaryColorV2,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  style: CustomTextTheme.customTextTheme()
                                      .headlineMedium!
                                      .copyWith(
                                        color:
                                            AppTheme.appTheme().kDullGreyColor,
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
                                      style: CustomTextTheme.customTextTheme()
                                          .displayLarge!
                                          .copyWith(
                                            color: AppTheme.appTheme()
                                                .kPrimaryColorV2,
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
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: missions.length,
                          itemBuilder: (context, index) {
                            final mission = missions[index];
                            return ExpansionTile(
                              initiallyExpanded: true,
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: AppTheme.appTheme().kDullGreyColor,
                                size: 24,
                              ),
                              title: Text(
                                mission.school!.name.toUpperCase(),
                                style: CustomTextTheme.customTextTheme()
                                    .headlineSmall!
                                    .copyWith(
                                      color: AppTheme.appTheme()
                                          .kAccent2BackgroundColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              children: [
                                ListTile(
                                  dense: true,
                                  minLeadingWidth: 10.5,
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                  visualDensity: VisualDensity.compact,
                                  onTap: () => context.router.push(
                                    MissionsDetailsRoute(mission: mission),
                                  ),
                                  title: Text(
                                    l10n.missionType(mission.missionType!.name),
                                    style: CustomTextTheme.customTextTheme()
                                        .headlineMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.missionStart(
                                          Misc.formatDate(mission.startDate),
                                          Misc.formatTime(mission.startTime),
                                        ),
                                        style: CustomTextTheme.customTextTheme()
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                      ),
                                      Text(
                                        PRFMissionStatusExtension.fromIndex(
                                          mission.status,
                                        ).name,
                                        style: CustomTextTheme.customTextTheme()
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: PRFMissionStatusExtension
                                                  .switchColor(
                                                PRFMissionStatusExtension
                                                    .fromIndex(
                                                  mission.status,
                                                ),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.upcoming.toUpperCase(),
                        style: CustomTextTheme.customTextTheme()
                            .headlineSmall!
                            .copyWith(
                              color:
                                  AppTheme.appTheme().kAccent2BackgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    BlocBuilder<GetMemberMissionSubscriptionsCubit,
                        GetMemberMissionSubscriptionsState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (message) => Center(child: Text(message)),
                          loaded: (missionSubscriptions) {
                            if (missionSubscriptions.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .25,
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    const Icon(
                                      Icons.directions_walk,
                                    ),
                                    Center(
                                      child: Text(
                                        l10n.noUpcomingMissions,
                                        style: CustomTextTheme.customTextTheme()
                                            .headlineMedium!
                                            .copyWith(
                                              color: AppTheme.appTheme()
                                                  .kDullGreyColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.05,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            l10n.pleaseWait,
                                            style: CustomTextTheme
                                                    .customTextTheme()
                                                .displayLarge!
                                                .copyWith(
                                                  color: AppTheme.appTheme()
                                                      .kPrimaryColorV2,
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
                            return SizedBox(
                              height: MediaQuery.sizeOf(context).height * .25,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: missionSubscriptions.length,
                                itemBuilder: (context, index) {
                                  final missionSubscription =
                                      missionSubscriptions[index];
                                  return ExpansionTile(
                                    initiallyExpanded: true,
                                    trailing: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppTheme.appTheme().kDullGreyColor,
                                      size: 24,
                                    ),
                                    title: Text(
                                      missionSubscription.mission!.school!.name
                                          .toUpperCase(),
                                      style: CustomTextTheme.customTextTheme()
                                          .headlineSmall!
                                          .copyWith(
                                            color: AppTheme.appTheme()
                                                .kAccent2BackgroundColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    children: [
                                      ListTile(
                                        dense: true,
                                        minLeadingWidth: 10.5,
                                        contentPadding:
                                            const EdgeInsets.only(left: 20),
                                        visualDensity: VisualDensity.compact,
                                        onTap: () => context.router.push(
                                          MyMissionsDetailsRoute(
                                            mission:
                                                missionSubscription.mission!,
                                          ),
                                        ),
                                        title: Text(
                                          l10n.missionType(
                                            missionSubscription
                                                .mission!.missionType!.name,
                                          ),
                                          style:
                                              CustomTextTheme.customTextTheme()
                                                  .headlineMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.missionStart(
                                                Misc.formatDate(
                                                  missionSubscription
                                                      .mission!.startDate,
                                                ),
                                                Misc.formatTime(
                                                  missionSubscription
                                                      .mission!.startTime,
                                                ),
                                              ),
                                              style: CustomTextTheme
                                                      .customTextTheme()
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Text(
                                              PRFMissionStatusExtension
                                                  .fromIndex(
                                                missionSubscription
                                                    .mission!.status,
                                              ).name,
                                              style: CustomTextTheme
                                                      .customTextTheme()
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        PRFMissionStatusExtension
                                                            .switchColor(
                                                      PRFMissionStatusExtension
                                                          .fromIndex(
                                                        missionSubscription
                                                            .mission!.status,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.past.toUpperCase(),
                        style: CustomTextTheme.customTextTheme()
                            .headlineSmall!
                            .copyWith(
                              color:
                                  AppTheme.appTheme().kAccent2BackgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    BlocBuilder<GetPastMemberMissionsCubit,
                        GetPastMemberMissionsState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (message) => Center(child: Text(message)),
                          loaded: (missionSubscriptions) {
                            if (missionSubscriptions.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .5,
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    const Icon(
                                      Icons.directions_walk,
                                    ),
                                    Center(
                                      child: Text(
                                        l10n.noPastMissions,
                                        style: CustomTextTheme.customTextTheme()
                                            .headlineMedium!
                                            .copyWith(
                                              color: AppTheme.appTheme()
                                                  .kDullGreyColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.05,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            l10n.pleaseWait,
                                            style: CustomTextTheme
                                                    .customTextTheme()
                                                .displayLarge!
                                                .copyWith(
                                                  color: AppTheme.appTheme()
                                                      .kPrimaryColorV2,
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
                            return SizedBox(
                              height: MediaQuery.sizeOf(context).height * .5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: missionSubscriptions.length,
                                itemBuilder: (context, index) {
                                  final missionSubscription =
                                      missionSubscriptions[index];
                                  return ExpansionTile(
                                    initiallyExpanded: true,
                                    trailing: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppTheme.appTheme().kDullGreyColor,
                                      size: 24,
                                    ),
                                    title: Text(
                                      missionSubscription.mission!.school!.name
                                          .toUpperCase(),
                                      style: CustomTextTheme.customTextTheme()
                                          .headlineSmall!
                                          .copyWith(
                                            color: AppTheme.appTheme()
                                                .kAccent2BackgroundColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    children: [
                                      ListTile(
                                        dense: true,
                                        minLeadingWidth: 10.5,
                                        contentPadding:
                                            const EdgeInsets.only(left: 20),
                                        visualDensity: VisualDensity.compact,
                                        onTap: () => context.router.push(
                                          MyMissionsDetailsRoute(
                                            mission:
                                                missionSubscription.mission!,
                                          ),
                                        ),
                                        title: Text(
                                          l10n.missionType(
                                            missionSubscription
                                                .mission!.missionType!.name,
                                          ),
                                          style:
                                              CustomTextTheme.customTextTheme()
                                                  .headlineMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.missionStart(
                                                Misc.formatDate(
                                                  missionSubscription
                                                      .mission!.startDate,
                                                ),
                                                Misc.formatTime(
                                                  missionSubscription
                                                      .mission!.startTime,
                                                ),
                                              ),
                                              style: CustomTextTheme
                                                      .customTextTheme()
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Text(
                                              PRFMissionStatusExtension
                                                  .fromIndex(
                                                missionSubscription
                                                    .mission!.status,
                                              ).name,
                                              style: CustomTextTheme
                                                      .customTextTheme()
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        PRFMissionStatusExtension
                                                            .switchColor(
                                                      PRFMissionStatusExtension
                                                          .fromIndex(
                                                        missionSubscription
                                                            .mission!.status,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
