import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/actions/add_debrief_note/_handset.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/feedback_data_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/finance_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/overview_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/people_data_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';

import 'package:app/features/home/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/actions/add_session/add_session.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/actions/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MissionsDetailsPageHandset extends StatefulWidget {
  const MissionsDetailsPageHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionsDetailsPageHandset> createState() =>
      _MissionsDetailsPageHandsetState();
}

class _MissionsDetailsPageHandsetState extends State<MissionsDetailsPageHandset>
    with SingleTickerProviderStateMixin {
  String get missionUlid => widget.missionUlid;

  static const _tabCount = 4;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabCount, vsync: this);

    context.read<MissionSubscriptionResourceCubit>().loadAll(
      filters: {'mission_ulid': widget.missionUlid},
    );
    context.read<MissionSessionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    context.read<SoulResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    context.read<DebriefNoteResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    context.read<MissionQuestionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          ColoredBox(
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                PRFBrandedNavBar(
                  title: l10n.missionDetails,
                  onBack: () => context.router.popUntilRouteWithPath(
                    PRFSuperAppRouter.missionsRoute,
                  ),
                  actions: [
                    BlocBuilder<
                      MissionResourceCubit,
                      ResourceState<PRFMission>
                    >(
                      builder: (context, state) => state.maybeWhen(
                        listLoading: () => const SizedBox.square(
                          dimension: 24,
                          child: PRFCircularProgressIndicator(),
                        ),
                        orElse: SizedBox.shrink,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.lg),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    PRFSpacingTokens.lg,
                    0,
                    PRFSpacingTokens.lg,
                    PRFSpacingTokens.sm,
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, -6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: theme.colorScheme.onPrimary,
                        unselectedLabelColor: theme.colorScheme.onPrimary
                            .withValues(alpha: 0.65),
                        indicatorColor: theme.colorScheme.secondary,
                        dividerColor: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                        labelStyle: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.sm,
                        ),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'People'),
                          Tab(text: 'Feedback'),
                          Tab(text: 'Finance'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OverviewSection(missionUlid: missionUlid),
                PeopleDataSection(
                  sessionsTab: SessionsView(missionUlid: missionUlid),
                  soulsTab: SoulsView(missionUlid: missionUlid),
                ),
                FeedbackDataSection(
                  debriefNotesTab: DebriefNotesView(
                    missionUlid: missionUlid,
                  ),
                  questionsTab: MissionQuestionsView(
                    missionUlid: missionUlid,
                  ),
                ),
                FinanceSection(
                  expensesTab: ExpensesView(missionUlid: missionUlid),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, l10n),
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Subscribe FAB
        BlocConsumer<SubscribeCubit, SubscribeState>(
          listener: (context, state) {
            state.mapOrNull(
              loaded: (_) {
                Gaimon.success();
                context.read<MissionSubscriptionResourceCubit>().loadAll(
                  filters: {'mission_ulid': missionUlid},
                );
                PRFSnackbar.success(
                  context,
                  l10n.successfullySubscribed,
                );
              },
              error: (error) {
                Gaimon.error();
                PRFSnackbar.error(context, error.message);
              },
            );
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  PRFRadiusTokens.md,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  FloatingActionButton.extended(
                    heroTag: 'subscribe',
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
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    icon: BlocBuilder<SubscribeCubit, SubscribeState>(
                      builder: (context, state) => state.maybeWhen(
                        orElse: () => const Icon(Icons.hail_rounded),
                        loading: () => const SizedBox.square(
                          dimension: 16,
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
                        delay: PRFMotionTokens.enterShort,
                      ),
                      const ScaleEffect(
                        begin: Offset(0.8, 0.8),
                        end: Offset(1, 1),
                        duration: PRFMotionTokens.slow,
                      ),
                    ],
                  ),
            );
          },
        ),

        const SizedBox(height: PRFSpacingTokens.md),

        // Quick-add actions menu
        PopupMenuButton<int>(
          icon: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(
                PRFRadiusTokens.md,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          onSelected: (value) => _onAddAction(context, value, l10n),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(l10n.addSession),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(l10n.addSoul),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(l10n.addNote),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(l10n.addQuestion),
            ),
            PopupMenuItem(
              value: 4,
              child: Text(l10n.addMissionPhotos),
            ),
          ],
        ),
      ],
    );
  }

  void _onAddAction(
    BuildContext context,
    int action,
    AppLocalizations l10n,
  ) {
    switch (action) {
      case 0:
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
            context.read<MissionSessionResourceCubit>().loadAll(
              filters: {'mission_ulid': missionUlid},
            );
          }
        });
      case 1:
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
            context.read<SoulResourceCubit>().loadAll(
              filters: {'mission_ulid': missionUlid},
            );
          }
        });
      case 2:
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
            context.read<DebriefNoteResourceCubit>().loadAll(
              filters: {'mission_ulid': missionUlid},
            );
          }
        });
      case 3:
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
            context.read<MissionQuestionResourceCubit>().loadAll(
              filters: {'mission_ulid': missionUlid},
            );
          }
        });
      case 4:
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
            context.read<MissionMediaResourceCubit>().loadMedia(
              missionUlid: missionUlid,
              collections: [
                PRFMediaModel.missionPhotos,
                PRFMediaModel.missionVideos,
              ],
            );
          }
        });
    }
  }
}
