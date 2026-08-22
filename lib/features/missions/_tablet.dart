import 'package:app/features/missions/_shared.dart';
import 'package:app/features/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/subscriptions_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionsPageTablet extends StatefulWidget {
  const MissionsPageTablet({super.key});

  @override
  State<MissionsPageTablet> createState() => _MissionsPageTabletState();
}

class _MissionsPageTabletState extends State<MissionsPageTablet>
    with SingleTickerProviderStateMixin, TimezoneMixin {
  late TabController _tabController;
  final _form = MissionsFormState();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _form
      ..attach(() => setState(() {}))
      ..initListeners(_tabController, context)
      ..loadTabData(0, context, force: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // The entrance cascade plays exactly once per screen instance.
    final animateEntrance = !_form.entrancePlayed;
    _form.entrancePlayed = true;

    return BlocBuilder<MissionResourceCubit, ResourceState<PRFMission>>(
      builder: (context, missionState) {
        return BlocBuilder<
          SubscriptionResourceCubit,
          ResourceState<PRFMissionSubscription>
        >(
          builder: (context, subscriptionState) {
            final isLoading =
                missionState.maybeWhen(
                  listLoading: (_) => true,
                  orElse: () => false,
                ) ||
                subscriptionState.maybeWhen(
                  listLoading: (_) => true,
                  orElse: () => false,
                );

            // Same source as the lists: counts and highlights never flash
            // zero mid-reload.
            final subscriptions = context
                .read<SubscriptionResourceCubit>()
                .currentItems;
            final subscribedMissions =
                subscriptions
                    .map((subscription) => subscription.mission)
                    .whereType<PRFMission>()
                    .groupListsBy((mission) => mission.ulid)
                    .values
                    .map((group) => group.first)
                    .toList()
                  ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return PRFTabletSplitScaffold(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.landingRoute,
                          ),
                        ),
                        const SizedBox(width: PRFSpacingTokens.xs),
                        Expanded(
                          child: Text(
                            l10n.missions,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (isLoading)
                          const SizedBox.square(
                            dimension: 24,
                            child: PRFCircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),

                  // Tabs + Search Text Field Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.xl,
                    ),
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
                        Tab(text: l10n.upcoming),
                        Tab(text: l10n.subscribed),
                        Tab(text: l10n.allPast),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    child: PRFTextField(
                      hintText: l10n.missionsSearchHint,
                      controller: _form.searchController,
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMissionsTimeline(
                          context,
                          animateEntrance: animateEntrance,
                        ),
                        _buildSubscribedMissionsTimeline(
                          context,
                          animateEntrance: animateEntrance,
                        ),
                        _buildPastMissionsTimeline(
                          context,
                          animateEntrance: animateEntrance,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Column - Living Root mission panel (flex: 2)
              sidePanel: _buildBrandPanel(
                l10n,
                theme,
                subscribedMissions: subscribedMissions,
                upcomingCount: context
                    .read<MissionResourceCubit>()
                    .currentItems
                    .length,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBrandPanel(
    AppLocalizations l10n,
    ThemeData theme, {
    required List<PRFMission> subscribedMissions,
    required int upcomingCount,
  }) {
    final nextMission = subscribedMissions.isEmpty
        ? null
        : subscribedMissions.first;

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PRFColors.navyBlue,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          child: Stack(
            children: [
              const Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(painter: PRFRootMotifPainter()),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (nextMission != null) ...[
                      _panelSectionLabel(l10n.yourNextMission, theme),
                      const SizedBox(height: PRFSpacingTokens.md),
                      _NextMissionCard(
                        mission: nextMission,
                        dateLabel: DateFormatter.formatDate(
                          nextMission.startDate,
                          timezone,
                        ),
                        onTap: () => context.router.push(
                          MissionsDetailsRoute(
                            missionUlid: nextMission.ulid,
                          ),
                        ),
                      ),
                      const SizedBox(height: PRFSpacingTokens.xl),
                    ] else ...[
                      Text(
                        l10n.missionsIntroBody,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: PRFColors.navy100,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: PRFSpacingTokens.xl),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: l10n.upcomingCount(upcomingCount),
                            background: Colors.white.withValues(alpha: 0.12),
                            foreground: Colors.white,
                            onTap: () => _tabController.animateTo(0),
                          ),
                        ),
                        const SizedBox(width: PRFSpacingTokens.sm),
                        Expanded(
                          child: _StatChip(
                            label: l10n.subscribedCount(
                              subscribedMissions.length,
                            ),
                            background: PRFColors.limeGreen,
                            foreground: PRFColors.navyBlue,
                            onTap: () => _tabController.animateTo(1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelSectionLabel(String label, ThemeData theme) {
    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: PRFColors.navy100,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildMissionsTimeline(
    BuildContext context, {
    required bool animateEntrance,
  }) {
    final l10n = context.l10n;

    return BlocBuilder<MissionResourceCubit, ResourceState<PRFMission>>(
      builder: (context, state) {
        final missions = context.read<MissionResourceCubit>().currentItems;

        final showInitialLoader =
            state is ResourceListLoading<PRFMission> && missions.isEmpty;

        if (showInitialLoader) {
          return const Center(child: PRFCircularProgressIndicator());
        }

        if (missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(0, context, force: true),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.pleaseWait,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _form.loadTabData(0, context, force: true),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.xl,
            ),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isLast = index == missions.length - 1;
              return buildAnimatedTimelineEntry(
                context: context,
                index: index,
                animate: animateEntrance,
                child: TimelineMissionCard(
                  mission: mission,
                  isLast: isLast,
                  onTap: () => context.router.push(
                    MissionsDetailsRoute(missionUlid: mission.ulid),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSubscribedMissionsTimeline(
    BuildContext context, {
    required bool animateEntrance,
  }) {
    final l10n = context.l10n;

    return BlocBuilder<
      SubscriptionResourceCubit,
      ResourceState<PRFMissionSubscription>
    >(
      builder: (context, state) {
        final subscriptions = context
            .read<SubscriptionResourceCubit>()
            .currentItems;

        final missions =
            subscriptions
                .map((subscription) => subscription.mission)
                .whereType<PRFMission>()
                .groupListsBy((mission) => mission.ulid)
                .values
                .map((missionGroup) => missionGroup.first)
                .toList()
              ..sort((a, b) => a.startDate.compareTo(b.startDate));

        final showInitialLoader =
            state is ResourceListLoading<PRFMissionSubscription> &&
            missions.isEmpty;

        if (showInitialLoader) {
          return const Center(child: PRFCircularProgressIndicator());
        }

        if (missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(1, context),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.pleaseWait,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _form.loadTabData(1, context),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.xl,
            ),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isLast = index == missions.length - 1;

              return buildAnimatedTimelineEntry(
                context: context,
                index: index,
                animate: animateEntrance,
                child: TimelineMissionCard(
                  mission: mission,
                  isLast: isLast,
                  isSubscribed: true,
                  onTap: () => context.router.push(
                    MissionsDetailsRoute(missionUlid: mission.ulid),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPastMissionsTimeline(
    BuildContext context, {
    required bool animateEntrance,
  }) {
    final l10n = context.l10n;

    return BlocBuilder<PastMissionResourceCubit, ResourceState<PRFSchool>>(
      builder: (context, state) {
        final schools = context.read<PastMissionResourceCubit>().currentItems;
        final showInitialLoader =
            state is ResourceListLoading<PRFSchool> && schools.isEmpty;

        if (showInitialLoader) {
          return const Center(child: PRFCircularProgressIndicator());
        }

        if (schools.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(2, context, force: true),
            child: PRFEmptyView(
              label: l10n.noPastMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.pleaseWait,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _form.loadTabData(2, context, force: true),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.xl,
            ),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final school = schools[index];
              final missionCount = school.missions.length;

              return buildAnimatedTimelineEntry(
                context: context,
                index: index,
                animate: animateEntrance,
                child: PRFSchoolCard(
                  schoolName: school.name,
                  address: school.address,
                  missionCount: missionCount > 0 ? missionCount : null,
                  onTap: () => context.router.push(
                    SchoolPastMissionsRoute(schoolUlid: school.ulid),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _NextMissionCard extends StatelessWidget {
  const _NextMissionCard({
    required this.mission,
    required this.dateLabel,
    required this.onTap,
  });

  final PRFMission mission;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.school?.name ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: PRFColors.limeGreen,
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                mission.theme ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                dateLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: PRFColors.limeGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: PRFSpacingTokens.md),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
