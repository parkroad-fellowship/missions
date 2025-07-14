import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/actions/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/actions/add_expense/add_expense.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/gallery.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_details/mission_details.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/actions/add_session/add_session.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/actions/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/shared_widgets/navbar/navbar.dart';
import 'package:app/shared_widgets/progress/circular_progress_indicator.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return Scaffold(
      body: DefaultTabController(
        length: tabCount,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomScrollView(
              physics: const ScrollPhysics(),
              slivers: [
                // Start Navigation Bar
                PRFNavBar(
                  title: l10n.missionDetails,
                  onBack: () => context.router.popUntilRouteWithPath(
                    PRFSuperAppRouter.missionsRoute,
                  ),
                ),
                // End Navigation Bar
                PinnedHeaderSliver(
                  child: ColoredBox(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      onTap: (value) => setState(() {
                        _currentTab = value;
                      }),
                      isScrollable: true,
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
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverFillRemaining(
                  fillOverscroll: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
        0 || 1 => BlocConsumer<SubscribeCubit, SubscribeState>(
          listener: (context, state) {
            state.mapOrNull(
              loaded: (_) {
                Gaimon.success();
                context.read<GetSubscribersCubit>().getSubscriptions(
                  missionUlid: missionUlid,
                  refresh: true,
                );
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
            final theme = Theme.of(context);
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child:
                  FloatingActionButton.extended(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    onPressed: () async =>
                        context.read<SubscribeCubit>().subscribe(
                          missionUlid: missionUlid,
                        ),
                    label: Text(
                      l10n.sendMe,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    icon: BlocBuilder<SubscribeCubit, SubscribeState>(
                      builder: (context, state) => state.maybeWhen(
                        orElse: () => const Icon(
                          Icons.hail_rounded,
                          size: 20,
                        ),
                        loading: () => const SizedBox.square(
                          dimension: 20,
                          child: PRFCircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ).animate(
                    effects: [
                      const ShimmerEffect(
                        duration: Duration(seconds: 2),
                        delay: Duration(milliseconds: 500),
                      ),
                      const ScaleEffect(
                        begin: Offset(0.8, 0.8),
                        end: Offset(1, 1),
                        duration: Duration(milliseconds: 400),
                      ),
                    ],
                  ),
            );
          },
        ),
        > 1 && < 8 => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              switch (_currentTab) {
                2 => l10n.addSession,
                3 => l10n.addSoul,
                4 => l10n.addNote,
                5 => l10n.addQuestion,
                6 => l10n.addExpense,
                7 => l10n.addMissionPhotos,
                _ => '',
              },
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
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
                          child: AddMissionQuestionView(
                            missionUlid: missionUlid,
                          ),
                        ),
                      ),
                    ];
                  },
                ).then((_) {
                  if (context.mounted) {
                    context
                        .read<GetMissionQuestionsCubit>()
                        .getMissionQuestions(
                          missionUlid: missionUlid,
                        );
                  }
                });
              }
              if (_currentTab == 6) {
                final missionExpense = getIt<HiveService>().data.expenses
                    .retrieveMissionExpense(missionUlid);
                if (missionExpense == null) {
                  Gaimon.error();
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text(l10n.pleaseWaitForFunds)),
                  );
                  return;
                }
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
                ).then((_) {
                  if (context.mounted) {
                    context.read<GetMissionMediaCubit>().getMissionMedia(
                      missionUlid: missionUlid,
                      model: PRFMediaModel.missionPhotos,
                    );
                  }
                });
              }
            },
          ),
        ),
        _ => null,
      },
    );
  }
}
