import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/feedback_data_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/finance_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/domain_sections/overview_section.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_ground/mission_ground.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/home/missions/mission_details/widgets/requisitions/requisitions_view.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/home/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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

  static const _tabCount = 3;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabCount, vsync: this);

    context.read<MissionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
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
            child: BlocBuilder<MissionResourceCubit, ResourceState<PRFMission>>(
              builder: (context, state) {
                final mission = state.maybeWhen(
                  listLoaded: (items, _, _) => items.firstWhereOrNull(
                    (m) => m.ulid == missionUlid,
                  ),
                  mutating: (items, _) => items.firstWhereOrNull(
                    (m) => m.ulid == missionUlid,
                  ),
                  mutated: (items, _, _) => items.firstWhereOrNull(
                    (m) => m.ulid == missionUlid,
                  ),
                  orElse: () => null,
                );

                if (state is ResourceListLoading<PRFMission> &&
                    mission == null) {
                  return const Center(
                    child: PRFCircularProgressIndicator(),
                  );
                }

                if (mission == null && state is ResourceError<PRFMission>) {
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
                        missionUlid: missionUlid,
                      ),
                    ),
                    FeedbackDataSection(
                      debriefNotesTab: DebriefNotesView(
                        missionUlid: missionUlid,
                      ),
                      soulsTab: SoulsView(
                        missionUlid: missionUlid,
                      ),
                      questionsTab: MissionQuestionsView(
                        missionUlid: missionUlid,
                      ),
                    ),
                    FinanceSection(
                      requisitionsTab: RequisitionsView(
                        missionUlid: missionUlid,
                      ),
                      expensesTab: ExpensesView(
                        missionUlid: missionUlid,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildSubscribeFab(context, l10n),
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
    );
  }
}
