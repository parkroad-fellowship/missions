import 'package:app/enums/prf_mission_status.dart';
import 'package:app/features/home/my_missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_past_member_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyMissionsPageHandset extends StatefulWidget {
  const MyMissionsPageHandset({super.key});

  @override
  State<MyMissionsPageHandset> createState() => _MyMissionsPageHandsetState();
}

class _MyMissionsPageHandsetState extends State<MyMissionsPageHandset> {
  @override
  void initState() {
    context.read<GetMemberMissionSubscriptionsCubit>().getUpcomingMissions();
    context.read<GetPastMemberMissionsCubit>().getPastMissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myMissions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.upcoming.toUpperCase(),
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            color: AppTheme.appTheme().kAccent2BackgroundColor,
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
                                      mission: missionSubscription.mission!,
                                    ),
                                  ),
                                  title: Text(
                                    l10n.missionType(
                                      missionSubscription
                                          .mission!.missionType!.name,
                                    ),
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
                                          Misc.formatDate(
                                            missionSubscription
                                                .mission!.startDate,
                                          ),
                                          Misc.formatTime(
                                            missionSubscription
                                                .mission!.startTime,
                                          ),
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
                                          missionSubscription.mission!.status,
                                        ).name,
                                        style: CustomTextTheme.customTextTheme()
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: PRFMissionStatusExtension
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
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            color: AppTheme.appTheme().kAccent2BackgroundColor,
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
                                      mission: missionSubscription.mission!,
                                    ),
                                  ),
                                  title: Text(
                                    l10n.missionType(
                                      missionSubscription
                                          .mission!.missionType!.name,
                                    ),
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
                                          Misc.formatDate(
                                            missionSubscription
                                                .mission!.startDate,
                                          ),
                                          Misc.formatTime(
                                            missionSubscription
                                                .mission!.startTime,
                                          ),
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
                                          missionSubscription.mission!.status,
                                        ).name,
                                        style: CustomTextTheme.customTextTheme()
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: PRFMissionStatusExtension
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
    );
  }
}
