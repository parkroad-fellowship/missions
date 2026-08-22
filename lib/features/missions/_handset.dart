import 'package:app/features/missions/_shared.dart';
import 'package:app/features/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/subscriptions_resource_cubit.dart';
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

class MissionsPageHandset extends StatefulWidget {
  const MissionsPageHandset({super.key});

  @override
  State<MissionsPageHandset> createState() => _MissionsPageHandsetState();
}

class _MissionsPageHandsetState extends State<MissionsPageHandset>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        TimezoneMixin {
  late TabController _tabController;
  final _form = MissionsFormState();

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // The entrance cascade plays exactly once per screen instance.
    final animateEntrance = !_form.entrancePlayed;
    _form.entrancePlayed = true;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          ColoredBox(
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                PRFBrandedNavBar(
                  title: l10n.missions,
                  onBack: () => context.router.popUntilRouteWithPath(
                    PRFSuperAppRouter.landingRoute,
                  ),
                  actions: [
                    BlocBuilder<
                      MissionResourceCubit,
                      ResourceState<PRFMission>
                    >(
                      builder: (context, state) => state.maybeWhen(
                        listLoading: (_) => const SizedBox.square(
                          dimension: 24,
                          child: PRFCircularProgressIndicator(),
                        ),
                        orElse: SizedBox.shrink,
                      ),
                    ),
                    const SizedBox(width: PRFSpacingTokens.sm),
                    BlocBuilder<
                      SubscriptionResourceCubit,
                      ResourceState<PRFMissionSubscription>
                    >(
                      builder: (context, state) => state.maybeWhen(
                        listLoading: (_) => const SizedBox.square(
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
                        tabs: [
                          Tab(text: l10n.upcoming),
                          Tab(text: l10n.subscribed),
                          Tab(text: l10n.allPast),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    PRFSpacingTokens.lg,
                    0,
                    PRFSpacingTokens.lg,
                    PRFSpacingTokens.lg,
                  ),
                  child: PRFTextField(
                    hintText: l10n.missionsSearchHint,
                    controller: _form.searchController,
                  ),
                ),
              ],
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
          return const Center(
            child: PRFCircularProgressIndicator(),
          );
        }

        if (missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(0, context, force: true),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.noMissionsDesc,
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
          return const Center(
            child: PRFCircularProgressIndicator(),
          );
        }

        if (missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(1, context),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.noMissionsDesc,
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
          return const Center(
            child: PRFCircularProgressIndicator(),
          );
        }

        if (schools.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _form.loadTabData(2, context, force: true),
            child: PRFEmptyView(
              label: l10n.noPastMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => l10n.noMissionsDesc,
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
