import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsDetailsPageHandset extends StatefulWidget {
  const MissionsDetailsPageHandset({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  State<MissionsDetailsPageHandset> createState() =>
      _MissionsDetailsPageHandsetState();
}

class _MissionsDetailsPageHandsetState
    extends State<MissionsDetailsPageHandset> {
  PRFMission get mission => widget.mission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.missionDetails,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(mission.school!.name.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.missionStart(
                      Misc.formatDate(mission.startDate),
                      Misc.formatTime(mission.startTime),
                    ),
                  ),
                  Text(
                    l10n.missionEnd(
                      Misc.formatDate(mission.endDate),
                      Misc.formatTime(mission.endTime),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ).name,
                    ),
                    backgroundColor: PRFMissionStatusExtension.switchColor(
                      PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (PRFMissionStatusExtension.fromIndex(
                        mission.status,
                      ) ==
                      PRFMissionStatus.approved)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      width: MediaQuery.sizeOf(context).height * 0.2,
                      child: BlocConsumer<SubscribeCubit, SubscribeState>(
                        listener: (context, state) {
                          state.mapOrNull(
                            loaded: (_) {
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                SnackBar(
                                  content: Text(l10n.successfullySubscribed),
                                ),
                              );
                            },
                            error: (error) {
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                SnackBar(content: Text(error.message)),
                              );
                            },
                          );
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async => context
                                .read<SubscribeCubit>()
                                .subscribe(missionUlid: mission.ulid)
                                .then(
                                  (_) => context
                                      .read<GetSubscribersCubit>()
                                      .getSubscriptions(
                                        missionUlid: mission.ulid,
                                        subscriptionStatus:
                                            PRFMissionSubscriptionStatus
                                                .pending,
                                      ),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.appTheme().kPrimaryColorV2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  l10n.sendMe,
                                  style: CustomTextTheme.customTextTheme()
                                      .displayLarge!
                                      .copyWith(
                                        color: AppTheme.appTheme()
                                            .kBackgroundColor,
                                        fontSize: 14,
                                      ),
                                ),
                                state.maybeWhen(
                                  orElse: () => Icon(
                                    Icons.hail_rounded,
                                    size: 16,
                                    color: AppTheme.appTheme().kBackgroundColor,
                                  ),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelStyle:
                        CustomTextTheme.customTextTheme().bodySmall?.copyWith(
                              color: AppTheme.appTheme().kPrimaryColorV2,
                            ),
                    indicatorColor: AppTheme.appTheme().kPrimaryColorV2,
                    isScrollable: true,
                    tabs: [
                      Tab(text: l10n.going),
                      Tab(text: l10n.going),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.84,
                    child: TabBarView(
                      children: [
                        SubscribersView(
                          missionUlid: mission.ulid,
                        ),
                        SubscribersView(
                          missionUlid: mission.ulid,
                        ),
                      ],
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
