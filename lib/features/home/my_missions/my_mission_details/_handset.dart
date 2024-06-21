import 'package:app/enums/prf_mission_status.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_details/mission_details.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MyMissionsDetailsPageHandset extends StatefulWidget {
  const MyMissionsDetailsPageHandset({
    required this.mission,
    super.key,
  });

  final PRFMission mission;

  @override
  State<MyMissionsDetailsPageHandset> createState() =>
      _MyMissionsDetailsPageHandsetState();
}

class _MyMissionsDetailsPageHandsetState
    extends State<MyMissionsDetailsPageHandset> {
  PRFMission get mission => widget.mission;
  int _currentTab = 0;

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
                  if (PRFMissionStatusExtension.fromIndex(
                            mission.status,
                          ) ==
                          PRFMissionStatus.approved &&
                      !Misc.memberHasSubscribed(mission) &&
                      Misc.canSubscribeToMission(mission))
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
                                  loading: () => const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (PRFMissionStatusExtension.fromIndex(
                            mission.status,
                          ) ==
                          PRFMissionStatus.approved &&
                      Misc.memberHasSubscribed(mission))
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      width: MediaQuery.sizeOf(context).height * 0.2,
                      child: BlocConsumer<WithdrawCubit, WithdrawState>(
                        listener: (context, state) {
                          state.mapOrNull(
                            loaded: (_) {
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                SnackBar(
                                  content: Text(l10n.successfullyWithdrawn),
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
                                .read<WithdrawCubit>()
                                .withdraw(
                                  missionUlid: mission.ulid,
                                  missionSubscriptionUlid: mission
                                      .loggedInMemberMissionSubscription!.ulid,
                                )
                                .then(
                                  (_) => context
                                      .read<GetSubscribersCubit>()
                                      .getSubscriptions(
                                        missionUlid: mission.ulid,
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
                                  l10n.withdraw,
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
                                    Icons.exposure_neg_1_outlined,
                                    size: 16,
                                    color: AppTheme.appTheme().kBackgroundColor,
                                  ),
                                  loading: () => const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
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
              length: 4,
              child: Column(
                children: <Widget>[
                  TabBar(
                    onTap: (value) => setState(() {
                      _currentTab = value;
                    }),
                    labelStyle:
                        CustomTextTheme.customTextTheme().bodySmall?.copyWith(
                              color: AppTheme.appTheme().kPrimaryColorV2,
                            ),
                    indicatorColor: AppTheme.appTheme().kPrimaryColorV2,
                    isScrollable: true,
                    tabs: [
                      Tab(text: l10n.going),
                      Tab(text: l10n.missionGround),
                      Tab(text: l10n.souls),
                      Tab(text: l10n.debriefNotes),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.84,
                    child: TabBarView(
                      children: [
                        SubscribersView(missionUlid: mission.ulid),
                        MissionDetailsView(mission: mission),
                        SoulsView(missionUlid: mission.ulid),
                        DebriefNotesView(missionUlid: mission.ulid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTab == 2 || _currentTab == 3
          ? FloatingActionButton(
              onPressed: () {
                if (_currentTab == 2) {
                  WoltModalSheet.show<void>(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      return [
                        WoltModalSheetPage(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.8,
                            child: AddSoulView(missionUlid: mission.ulid),
                          ),
                        ),
                      ];
                    },
                    maxDialogWidth: 560,
                    minDialogWidth: 400,
                    minPageHeight: 0,
                    maxPageHeight: 0.9,
                  ).then(
                    (_) => context
                        .read<GetSoulsCubit>()
                        .getSouls(missionUlid: mission.ulid),
                  );
                }
                if (_currentTab == 3) {
                  WoltModalSheet.show<void>(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      return [
                        WoltModalSheetPage(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.8,
                            child: AddDebriefNoteViewHandset(
                              missionUlid: mission.ulid,
                            ),
                          ),
                        ),
                      ];
                    },
                    maxDialogWidth: 560,
                    minDialogWidth: 400,
                    minPageHeight: 0,
                    maxPageHeight: 0.9,
                  ).then(
                    (_) => context
                        .read<GetDebriefNotesCubit>()
                        .getDebriefNotes(missionUlid: mission.ulid),
                  );
                }
              },
              backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
              tooltip: l10n.recordSoul,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
