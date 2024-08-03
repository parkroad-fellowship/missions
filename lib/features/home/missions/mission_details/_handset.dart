import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_details/mission_details.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

class _MissionsDetailsPageHandsetState extends State<MissionsDetailsPageHandset>
    with SingleTickerProviderStateMixin {
  PRFMission get mission => widget.mission;

  late TabController _tabController;
  int _currentTab = 0;

  void _changeTab() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
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
        length: 5,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Row(
                    children: [
                      Container(
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
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.missionsRoute,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.missionDetails,
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 80.sp),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  onTap: (value) => setState(() {
                    Logger().d(value);
                    _currentTab = value;
                  }),
                  dividerColor: Colors.white,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle:
                      CustomTextTheme.customTextTheme().displayMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.appTheme().kPrimaryColorV2,
                          ),
                  indicatorColor: Colors.white,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    Tab(text: l10n.missionGround),
                    Tab(text: l10n.going),
                    Tab(text: l10n.souls),
                    Tab(text: l10n.debriefNotes),
                    Tab(text: l10n.missionQuestions),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      MissionDetailsView(mission: mission),
                      SubscribersView(missionUlid: mission.ulid),
                      SoulsView(missionUlid: mission.ulid),
                      DebriefNotesView(missionUlid: mission.ulid),
                      MissionQuestionsView(missionUlid: mission.ulid),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: switch (_currentTab) {
        1 => BlocConsumer<SubscribeCubit, SubscribeState>(
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
              return FloatingActionButton.extended(
                onPressed: () async => context
                    .read<SubscribeCubit>()
                    .subscribe(missionUlid: mission.ulid)
                    .then(
                      (_) => context
                          .read<GetSubscribersCubit>()
                          .getSubscriptions(missionUlid: mission.ulid),
                    ),
                backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
                label: Text(
                  l10n.sendMe,
                  style: CustomTextTheme.customTextTheme()
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.hail_rounded,
                  color: Colors.white,
                ),
              );
            },
          ),
        > 1 && < 5 => FloatingActionButton(
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
                ).then(
                  (_) => context
                      .read<GetDebriefNotesCubit>()
                      .getDebriefNotes(missionUlid: mission.ulid),
                );
              }
              if (_currentTab == 4) {
                WoltModalSheet.show<void>(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    return [
                      WoltModalSheetPage(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.8,
                          child: AddMissionQuestionView(
                            missionUlid: mission.ulid,
                          ),
                        ),
                      ),
                    ];
                  },
                ).then(
                  (_) => context
                      .read<GetMissionQuestionsCubit>()
                      .getMissionQuestions(missionUlid: mission.ulid),
                );
              }
            },
            backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        _ => null,
      },
    );
  }
}
