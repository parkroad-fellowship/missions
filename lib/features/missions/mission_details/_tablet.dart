import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/missions/mission_details/_shared.dart';
import 'package:app/features/missions/mission_details/cubit/mission_details_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/debrief_notes.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/feedback_data_section.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/finance_section.dart';
import 'package:app/features/missions/mission_details/widgets/domain_sections/overview_section.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/expenses.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/gallery.dart';
import 'package:app/features/missions/mission_details/widgets/mission_ground/mission_ground.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/mission_questions.dart';
import 'package:app/features/missions/mission_details/widgets/requisitions/requisitions_view.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/sessions.dart';
import 'package:app/features/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/souls/souls.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/subscribers.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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

    return BlocBuilder<MissionDetailsResourceCubit, ResourceState<PRFMission>>(
      builder: (context, state) {
        final mission = state.maybeWhen(
          itemLoaded: (item, _) => item,
          itemLoading: (_, item) => item,
          itemError: (_, _, item) => item,
          orElse: () => null,
        );

        if (state is ResourceItemLoading<PRFMission> && mission == null) {
          return const Scaffold(
            body: Center(
              child: PRFCircularProgressIndicator(),
            ),
          );
        }

        if (mission == null && state is ResourceItemError<PRFMission>) {
          return Scaffold(
            body: Center(
              child: PRFErrorView.fromMessage(
                message: state.message,
              ),
            ),
          );
        }

        if (mission == null) {
          return const Scaffold(
            body: Center(
              child: PRFCircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Interactive Tabs & Sub-sections (flex: 3)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => context.router.pop(),
                                ),
                                const SizedBox(width: PRFSpacingTokens.xs),
                                Expanded(
                                  child: Text(
                                    l10n.missionDetails,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                  ),
                                ),
                                if (state is ResourceItemLoading<PRFMission>)
                                  const SizedBox.square(
                                    dimension: 24,
                                    child: PRFCircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),

                          // TabBar for Overview, Feedback, Finance
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.xl,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelColor: theme.colorScheme.primary,
                                unselectedLabelColor:
                                    theme.colorScheme.onSurfaceVariant,
                                indicatorColor: theme.colorScheme.primary,
                                dividerColor: theme.colorScheme.outline
                                    .withValues(alpha: 0.12),
                                labelStyle: theme.textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                tabs: const [
                                  Tab(text: 'Overview'),
                                  Tab(text: 'Feedback Data'),
                                  Tab(text: 'Finance'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: PRFSpacingTokens.lg),

                          Expanded(
                            child: TabBarView(
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
                                    accountingEventUlid:
                                        mission.accountingEvent?.ulid,
                                    canEdit: mission.canEdit,
                                  ),
                                  requisitionsTab: RequisitionsView(
                                    accountingEventUlid:
                                        mission.accountingEvent?.ulid,
                                  ),
                                  initialIndex: _subTabIndexes[2]!,
                                  onTabChanged: (index) =>
                                      setState(() => _subTabIndexes[2] = index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Mission Metadata Summary & Contextual Action FAB (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mission Overview',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Mini information box
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  PRFRadiusTokens.md,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mission.school?.name ??
                                        'School not specified',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.xs),
                                  Text(
                                    mission.missionType?.name ??
                                        'General Mission',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.lg),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PRFSpacingTokens.md,
                                      vertical: PRFSpacingTokens.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.sm,
                                      ),
                                    ),
                                    child: Text(
                                      mission.status.name,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Helpful guidance card
                            Center(
                              child: Icon(
                                Icons.explore_outlined,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Interactive Actions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'The button below dynamically adapts to your current selected tab. Add sessions, write debriefs, register souls, or report expenses seamlessly.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),

                            // The unified, floating button docked cleanly inside the right sidebar
                            SizedBox(
                              width: double.infinity,
                              child: _buildDynamicFab(context, l10n, mission),
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicFab(
    BuildContext context,
    AppLocalizations l10n,
    PRFMission? mission,
  ) {
    if (mission == null) return const SizedBox.shrink();

    final config = getFABConfig(
      context: context,
      l10n: l10n,
      mission: mission,
      missionUlid: missionUlid,
      mainTabIndex: _mainTabIndex,
      subTabIndexes: _subTabIndexes,
    );
    if (!config.visible) return const SizedBox.shrink();

    final theme = Theme.of(context);

    // If it's the subscribe action, we use the original BlocConsumer for logic
    if (config.label == l10n.sendMe) {
      return _buildSubscribeFab(context, l10n);
    }

    if (!mission.canEdit) {
      return const SizedBox.shrink();
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
            heroTag: 'dynamic-fab-tablet-${config.label}',
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
                heroTag: 'subscribe-tablet',
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
