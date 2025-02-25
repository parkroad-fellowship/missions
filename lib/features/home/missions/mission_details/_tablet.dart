import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_expense/add_expense.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_media/add_media.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_session/add_session.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/gallery.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_details/mission_details.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/circular_progress_indicator.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MissionsDetailsPageTablet extends StatefulWidget {
  const MissionsDetailsPageTablet({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionsDetailsPageTablet> createState() =>
      _MissionsDetailsPageTabletState();
}

class _MissionsDetailsPageTabletState extends State<MissionsDetailsPageTablet>
    with SingleTickerProviderStateMixin {
  String get missionUlid => widget.missionUlid;

  int tabCount = 8;

  late TabController _tabController;
  int _currentTab = 0;

  void _changeTab() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this);
    _tabController.addListener(_changeTab);

    context.read<GetSubscribersCubit>().getSubscriptions(
      missionUlid: widget.missionUlid,
      refresh: true,
    );
    context.read<GetMissionQuestionsCubit>().getMissionQuestions(
      missionUlid: missionUlid,
      refresh: true,
    );
    context.read<GetDebriefNotesCubit>().getDebriefNotes(
      missionUlid: missionUlid,
      refresh: true,
    );
    context.read<GetSoulsCubit>().getSouls(
      missionUlid: missionUlid,
      refresh: true,
    );
    context.read<GetMissionSessionsCubit>().getMissionSessions(
      missionUlid: missionUlid,
      refresh: true,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_changeTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);

    return Scaffold(
      body: DefaultTabController(
        length: tabCount,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomScrollView(
              physics: const ScrollPhysics(),
              slivers: [
                // Start Navigation Bar
                PinnedHeaderSliver(
                  child: ColoredBox(
                    color: Colors.white,
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
                                color: PRFApp.theme().kPrimaryColorV2,
                                width: 1.w,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              padding: const EdgeInsets.only(left: 8),
                              onPressed:
                                  () => context.router.popUntilRouteWithPath(
                                    PRFSuperAppRouter.missionsRoute,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.missionDetails,
                            style: PRFText.theme().displayLarge?.copyWith(
                              fontSize: 56.sp,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),

                // End Navigation Bar
                PinnedHeaderSliver(
                  child: ColoredBox(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      onTap:
                          (value) => setState(() {
                            _currentTab = value;
                          }),
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
                        Tab(text: l10n.missionGround),
                        Tab(text: l10n.going),
                        Tab(text: l10n.sessions),
                        Tab(text: l10n.souls),
                        Tab(text: l10n.debriefNotes),
                        Tab(text: l10n.missionQuestions),
                        Tab(text: l10n.expenses),
                        Tab(text: l10n.gallery),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  fillOverscroll: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MissionDetailsView(missionUlid: missionUlid),
                        SubscribersView(missionUlid: missionUlid),
                        SessionsView(missionUlid: missionUlid),
                        SoulsView(missionUlid: missionUlid),
                        DebriefNotesView(missionUlid: missionUlid),
                        MissionQuestionsView(missionUlid: missionUlid),
                        ExpensesView(missionUlid: missionUlid),
                        GalleryView(missionUlid: missionUlid),
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
        1 => BlocConsumer<SubscribeCubit, SubscribeState>(
          listener: (context, state) {
            state.mapOrNull(
              loaded: (_) {
                Gaimon.success();
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(content: Text(l10n.successfullySubscribed)),
                );
              },
              error: (error) {
                Gaimon.error();
                ScaffoldMessenger.maybeOf(
                  context,
                )?.showSnackBar(SnackBar(content: Text(error.message)));
              },
            );
          },
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed:
                  () async => context
                      .read<SubscribeCubit>()
                      .subscribe(missionUlid: missionUlid)
                      .then((_) {
                        if (context.mounted) {
                          context.read<GetSubscribersCubit>().getSubscriptions(
                            missionUlid: missionUlid,
                          );
                        }
                      }),
              backgroundColor: PRFApp.theme().kPrimaryColorV2,
              label: Text(
                l10n.sendMe,
                style: PRFText.theme().bodySmall?.copyWith(color: Colors.white),
              ),
              icon: BlocBuilder<SubscribeCubit, SubscribeState>(
                builder:
                    (context, state) => state.maybeWhen(
                      orElse:
                          () => const Icon(
                            Icons.hail_rounded,
                            color: Colors.white,
                          ),
                      loading:
                          () => const SizedBox.square(
                            dimension: 16,
                            child: PRFCircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                    ),
              ),
            );
          },
        ),
        > 1 && < 8 => FloatingActionButton(
          onPressed: () {
            if (_currentTab == 2) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddSessionView(missionUlid: missionUlid),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<GetMissionSessionsCubit>().getMissionSessions(
                    missionUlid: missionUlid,
                  );
                }
              });
            }
            if (_currentTab == 3) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddSoulView(missionUlid: missionUlid),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<GetSoulsCubit>().getSouls(
                    missionUlid: missionUlid,
                  );
                }
              });
            }
            if (_currentTab == 4) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddDebriefNoteViewHandset(
                          missionUlid: missionUlid,
                        ),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<GetDebriefNotesCubit>().getDebriefNotes(
                    missionUlid: missionUlid,
                  );
                }
              });
            }
            if (_currentTab == 5) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddMissionQuestionView(missionUlid: missionUlid),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<GetMissionQuestionsCubit>().getMissionQuestions(
                    missionUlid: missionUlid,
                  );
                }
              });
            }
            if (_currentTab == 6) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddExpenseView(missionUlid: missionUlid),
                      ),
                    ),
                  ];
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<GetMissionExpenseCubit>().getMissionExpense(
                    missionUlid: missionUlid,
                  );
                }
              });
            }

            if (_currentTab == 7) {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    WoltModalSheetPage(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        child: AddMediaView(missionUlid: missionUlid),
                      ),
                    ),
                  ];
                },
              );
            }
          },
          backgroundColor: PRFApp.theme().kPrimaryColorV2,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        _ => null,
      },
    );
  }
}
