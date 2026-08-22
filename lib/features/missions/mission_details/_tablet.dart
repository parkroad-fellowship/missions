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

        if (state is ResourceItemError<PRFMission> && mission == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PRFTabletHeaderRow(
                    title: l10n.missionDetails,
                    onBack: () => context.router.pop(),
                  ),
                  Expanded(
                    child: PRFErrorView.fromMessage(
                      message: state.message,
                      onRetry: () => context
                          .read<MissionDetailsResourceCubit>()
                          .loadMission(
                            missionUlid: missionUlid,
                            refresh: true,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (mission == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PRFTabletHeaderRow(
                    title: l10n.missionDetails,
                    onBack: () => context.router.pop(),
                    isLoading: true,
                  ),
                  const Expanded(
                    child: Center(child: PRFCircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoading = state is ResourceItemLoading<PRFMission>;

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.missionDetails,
                onBack: () => context.router.pop(),
                isLoading: isLoading,
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
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    indicatorColor: theme.colorScheme.primary,
                    dividerColor: theme.colorScheme.outline.withValues(
                      alpha: 0.12,
                    ),
                    labelStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(text: l10n.overviewTab),
                      Tab(text: l10n.feedbackDataTab),
                      Tab(text: l10n.financeTab),
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
                ),
              ),
            ],
          ),
          sidePanel: _buildBrandPanel(context, l10n, mission),
        );
      },
    );
  }

  Widget _buildBrandPanel(
    BuildContext context,
    AppLocalizations l10n,
    PRFMission mission,
  ) {
    final theme = Theme.of(context);

    return PRFBrandPanel(
      children: [
        PRFPanelSectionLabel(l10n.missionOverview),
        const SizedBox(height: PRFSpacingTokens.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.school?.name ?? l10n.schoolNotSpecified,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                mission.missionType?.name ?? l10n.generalMission,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.md,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Text(
                  mission.status.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        Center(
          child: Icon(
            Icons.explore_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
          l10n.interactiveActions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        Text(
          l10n.missionActionsGuidance,
          style: theme.textTheme.bodySmall?.copyWith(
            color: PRFColors.navy100,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.xl),
        SizedBox(
          width: double.infinity,
          child: _buildDynamicFab(context, l10n, mission),
        ),
      ],
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

    // Lime-on-navy keeps the action visible against the brand panel.
    if (config.label == l10n.sendMe) {
      return _buildSubscribeFab(context, l10n);
    }

    if (!mission.canEdit) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      heroTag: 'dynamic-fab-tablet-${config.label}',
      backgroundColor: PRFColors.limeGreen,
      foregroundColor: PRFColors.navyBlue,
      onPressed: config.onPressed,
      label: Text(
        config.label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: PRFColors.navyBlue,
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
    );
  }

  Widget _buildSubscribeFab(BuildContext context, AppLocalizations l10n) {
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
        return FloatingActionButton.extended(
          heroTag: 'subscribe-tablet',
          backgroundColor: PRFColors.limeGreen,
          foregroundColor: PRFColors.navyBlue,
          onPressed: () async => context.read<SubscribeCubit>().subscribe(
            missionUlid: missionUlid,
          ),
          label: Text(
            l10n.sendMe,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: PRFColors.navyBlue,
            ),
          ),
          icon: BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () =>
                  const Icon(Icons.hail_rounded, color: PRFColors.navyBlue),
              loading: () => const SizedBox.square(
                dimension: 16,
                child: PRFCircularProgressIndicator(color: PRFColors.navyBlue),
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
        );
      },
    );
  }
}
