import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/missions/mission_details/cubit/mission_details_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/actions/debrief_note_form/debrief_note_form.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/feedback_data_section.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/finance_section.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/overview_section.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/actions/add_expense/add_expense.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/gallery.dart';
import 'package:app/features/missions/mission_details/widgets/mission_ground/mission_ground.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/add_mission_question/add_mission_question.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/missions/mission_details/widgets/requisitions/requisitions_view.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/session_form.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/missions/mission_details/widgets/souls/actions/soul_form/soul_form.dart';
import 'package:app/features/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

class MissionsDetailsPageHandset extends StatefulWidget {
  const MissionsDetailsPageHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionsDetailsPageHandset> createState() =>
      _MissionsDetailsPageHandsetState();
}

class _FABConfig {
  const _FABConfig({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.visible = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool visible;
}

class _MissionsDetailsPageHandsetState extends State<MissionsDetailsPageHandset>
    with SingleTickerProviderStateMixin {
  String get missionUlid => widget.missionUlid;

  static const _tabCount = 3;

  late TabController _tabController;

  int _mainTabIndex = 0;
  final Map<int, int> _subTabIndexes = {0: 0, 1: 0, 2: 0};

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _tabController.index != _mainTabIndex) {
        setState(() {
          _mainTabIndex = _tabController.index;
        });
      }
    });

    Future.wait([
      context.read<MissionSubscriptionResourceCubit>().loadAll(
        filters: {'mission_ulid': widget.missionUlid},
      ),
      context.read<MissionSessionResourceCubit>().loadAll(
        filters: {'mission_ulid': missionUlid},
      ),
      context.read<DebriefNoteResourceCubit>().loadAll(
        filters: {'mission_ulid': missionUlid},
      ),
      context.read<SoulResourceCubit>().loadAll(
        filters: {'mission_ulid': missionUlid},
      ),
      context.read<MissionQuestionResourceCubit>().loadAll(
        filters: {'mission_ulid': missionUlid},
      ),

      context.read<MissionMediaResourceCubit>().loadMedia(
        missionUlid: missionUlid,
        collections: [
          PRFMediaModel.missionPhotos,
          PRFMediaModel.missionVideos,
        ],
      ),
    ]);
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
                      MissionDetailsResourceCubit,
                      ResourceState<PRFMission>
                    >(
                      builder: (context, state) => state.maybeWhen(
                        itemLoading: (_, _) => const SizedBox.square(
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
                        tabAlignment: TabAlignment.start,
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
                          Tab(text: 'Feedback Data'),
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
            child:
                BlocBuilder<
                  MissionDetailsResourceCubit,
                  ResourceState<PRFMission>
                >(
                  builder: (context, state) {
                    final mission = state.maybeWhen(
                      itemLoaded: (item, _) => item,
                      itemLoading: (_, item) => item,
                      itemError: (_, _, item) => item,
                      orElse: () => null,
                    );

                    if (state is ResourceItemLoading<PRFMission> &&
                        mission == null) {
                      return const Center(
                        child: PRFCircularProgressIndicator(),
                      );
                    }

                    if (mission == null &&
                        state is ResourceItemError<PRFMission>) {
                      return Center(
                        child: PRFErrorView.fromMessage(
                          message: state.message,
                        ),
                      );
                    }

                    if (mission == null) {
                      return const Center(
                        child: PRFCircularProgressIndicator(),
                      );
                    }

                    Logger().f(mission.accountingEvent);

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        OverviewSection(
                          missionGround: MissionGroundView(
                            missionUlid: missionUlid,
                          ),
                          subscribers: SubscribersView(
                            missionUlid: missionUlid,
                          ),
                          sessions: SessionsView(
                            mission: mission,
                          ),
                          initialIndex: _subTabIndexes[0]!,
                          onTabChanged: (index) =>
                              setState(() => _subTabIndexes[0] = index),
                        ),
                        FeedbackDataSection(
                          debriefNotesTab: DebriefNotesView(
                            mission: mission,
                          ),
                          soulsTab: SoulsView(
                            mission: mission,
                          ),
                          questionsTab: MissionQuestionsView(
                            mission: mission,
                          ),
                          galleryTab: GalleryView(
                            mission: mission,
                          ),
                          initialIndex: _subTabIndexes[1]!,
                          onTabChanged: (index) =>
                              setState(() => _subTabIndexes[1] = index),
                        ),
                        FinanceSection(
                          expensesTab: ExpensesView(
                            accountingEventUlid: mission.accountingEvent?.ulid,
                            canEdit: mission.canEdit,
                          ),
                          requisitionsTab: RequisitionsView(
                            accountingEventUlid: mission.accountingEvent?.ulid,
                          ),
                          initialIndex: _subTabIndexes[2]!,
                          onTabChanged: (index) =>
                              setState(() => _subTabIndexes[2] = index),
                        ),
                      ],
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton:
          BlocBuilder<MissionDetailsResourceCubit, ResourceState<PRFMission>>(
            builder: (context, state) {
              final mission = state.maybeWhen(
                itemLoaded: (item, _) => item,
                itemLoading: (_, item) => item,
                itemError: (_, _, item) => item,
                orElse: () => null,
              );
              if (mission == null) return const SizedBox.shrink();
              if (!mission.canEdit) {
                return const SizedBox.shrink();
              }
              return _buildDynamicFab(context, l10n, mission);
            },
          ),
    );
  }

  Widget _buildDynamicFab(
    BuildContext context,
    AppLocalizations l10n,
    PRFMission? mission,
  ) {
    if (mission == null) return const SizedBox.shrink();

    final config = _getFABConfig(context, l10n, mission);
    if (!config.visible) return const SizedBox.shrink();

    final theme = Theme.of(context);

    // If it's the subscribe action, we use the original BlocConsumer for logic
    if (config.label == l10n.sendMe) {
      return _buildSubscribeFab(context, l10n);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          FloatingActionButton.extended(
            heroTag: 'dynamic-fab-${config.label}',
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            onPressed: config.onPressed,
            label: Text(
              config.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            icon: Icon(config.icon),
          ).animate(
            effects: [
              const ScaleEffect(
                begin: Offset(0.8, 0.8),
                end: Offset(1, 1),
                duration: PRFMotionTokens.slow,
              ),
            ],
          ),
    );
  }

  _FABConfig _getFABConfig(
    BuildContext context,
    AppLocalizations l10n,
    PRFMission mission,
  ) {
    final subTabIndex = _subTabIndexes[_mainTabIndex] ?? 0;

    switch (_mainTabIndex) {
      case 0: // Overview
        if (subTabIndex == 2) {
          // Sessions
          return _FABConfig(
            icon: Icons.add_task_rounded,
            label: l10n.addSession,
            onPressed: () => PRFBottomSheet.show<void>(
              context,
              title: l10n.addSession,
              child: SessionFormView(missionUlid: missionUlid),
            ),
          );
        }
        // Default for Overview: Subscribe
        return _FABConfig(
          icon: Icons.hail_rounded,
          label: l10n.sendMe,
          onPressed: () {}, // Handled by _buildSubscribeFab
        );

      case 1: // Feedback Data
        switch (subTabIndex) {
          case 0: // Debrief Notes
            return _FABConfig(
              icon: Icons.note_add_rounded,
              label: l10n.addDebriefNote,
              onPressed: () => PRFBottomSheet.show<void>(
                context,
                title: l10n.addDebriefNote,
                child: DebriefNoteFormView(missionUlid: missionUlid),
              ),
            );
          case 1: // Souls
            return _FABConfig(
              icon: Icons.person_add_rounded,
              label: l10n.addSoul,
              onPressed: () => PRFBottomSheet.show<void>(
                context,
                title: l10n.addSoul,
                child: SoulFormView(missionUlid: missionUlid),
              ),
            );
          case 2: // Questions
            return _FABConfig(
              icon: Icons.quiz_rounded,
              label: l10n.addQuestion,
              onPressed: () => PRFBottomSheet.show<void>(
                context,
                title: l10n.addQuestion,
                child: AddMissionQuestionView(missionUlid: missionUlid),
              ),
            );
          case 3: // Gallery
            return _FABConfig(
              icon: Icons.add_photo_alternate_rounded,
              label: l10n.addMissionPhotos,
              onPressed: () => PRFBottomSheet.show<void>(
                context,
                title: l10n.addMissionPhotos,
                child: AddMediaView(missionUlid: missionUlid),
              ),
            );
          default:
            return _FABConfig(
              icon: Icons.add,
              label: '',
              onPressed: () {},
              visible: false,
            );
        }

      case 2: // Finance
        if (subTabIndex == 0) {
          // Expenses
          final accountingEventUlid = mission.accountingEvent?.ulid;
          return _FABConfig(
            icon: Icons.add_card_rounded,
            label: l10n.addExpense,
            onPressed: () {
              if (accountingEventUlid != null) {
                PRFBottomSheet.show<void>(
                  context,
                  title: l10n.addExpense,
                  child: AddExpenseView(
                    accountingEventUlid: accountingEventUlid,
                  ),
                );
              }
            },
            visible: accountingEventUlid != null,
          );
        }
        return _FABConfig(
          icon: Icons.add,
          label: '',
          onPressed: () {},
          visible: false,
        );
    }

    // Default: hidden
    return _FABConfig(
      icon: Icons.add,
      label: '',
      onPressed: () {},
      visible: false,
    );
  }

  Widget _buildSubscribeFab(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return BlocConsumer<SubscribeCubit, SubscribeState>(
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
                onPressed: () async => context.read<SubscribeCubit>().subscribe(
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
                        color: PRFColors.white,
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
    );
  }
}
