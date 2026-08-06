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
import 'package:flutter_animate/flutter_animate.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

    return BlocBuilder<MissionResourceCubit, ResourceState<PRFMission>>(
      builder: (context, missionState) {
        return BlocBuilder<
          SubscriptionResourceCubit,
          ResourceState<PRFMissionSubscription>
        >(
          builder: (context, subscriptionState) {
            final missions = missionState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFMission>.empty,
            );
            final subscriptions = subscriptionState.maybeWhen(
              listLoaded: (values, _, _) => values,
              orElse: List<PRFMissionSubscription>.empty,
            );

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Column - Timeline & Tabs (flex: 3)
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.lg,
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () => context.router
                                            .popUntilRouteWithPath(
                                              PRFSuperAppRouter.landingRoute,
                                            ),
                                      ),
                                      const SizedBox(
                                        width: PRFSpacingTokens.xs,
                                      ),
                                      Expanded(
                                        child: Text(
                                          l10n.missions,
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                      if (missionState.maybeWhen(
                                            listLoading: (_) => true,
                                            orElse: () => false,
                                          ) ||
                                          subscriptionState.maybeWhen(
                                            listLoading: (_) => true,
                                            orElse: () => false,
                                          ))
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
                                    unselectedLabelColor:
                                        theme.colorScheme.onSurfaceVariant,
                                    indicatorColor: theme.colorScheme.primary,
                                    dividerColor: theme.colorScheme.outline
                                        .withValues(alpha: 0.12),
                                    labelStyle: theme.textTheme.titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                    tabs: [
                                      const Tab(text: 'Upcoming'),
                                      Tab(text: l10n.subscribed),
                                      const Tab(text: 'All Past'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.lg,
                                  ),
                                  child: PRFTextField(
                                    hintText: l10n.missionsSearchHint,
                                    controller: _form.searchController,
                                  ),
                                ),

                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildMissionsTimeline(context, columns),
                                      _buildSubscribedMissionsTimeline(
                                        context,
                                        columns,
                                      ),
                                      _buildPastMissionsTimeline(
                                        context,
                                        columns,
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
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),

                          // Right Column - Mission Stats & Brand Sidebar (flex: 2)
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                              padding: const EdgeInsets.all(
                                PRFSpacingTokens.xl,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
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
                                    'Mission Center',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.xl),

                                  // Stats Card
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Participate in school missions, record answers to queries, and touch lives.',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                height: 1.4,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: PRFSpacingTokens.lg,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  PRFSpacingTokens.sm,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        PRFRadiusTokens.md,
                                                      ),
                                                ),
                                                child: Text(
                                                  '${missions.length} Upcoming',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: PRFSpacingTokens.sm,
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  PRFSpacingTokens.sm,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .prfColors
                                                      .limeGreen
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        PRFRadiusTokens.md,
                                                      ),
                                                ),
                                                child: Text(
                                                  '${subscriptions.length} Active',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: context
                                                            .prfColors
                                                            .limeGreen,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Guidance illustrative elements
                                  Center(
                                    child: Icon(
                                      Icons.explore_outlined,
                                      size: 64,
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.md),
                                  Text(
                                    'Engage and Connect',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: PRFSpacingTokens.sm),
                                  Text(
                                    'Filter and search upcoming and past missions. Tap any mission card to explore full statistics, subscribe, or submit expenses and debriefs.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMissionsTimeline(BuildContext context, int columns) {
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
              return TimelineMissionCard(
                    mission: mission,
                    isLast: isLast,
                    onTap: () => context.router.push(
                      MissionsDetailsRoute(
                        missionUlid: mission.ulid,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: index * 100),
                    duration: PRFMotionTokens.enterShort,
                  )
                  .slideX(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        );
      },
    );
  }

  Widget _buildSubscribedMissionsTimeline(BuildContext context, int columns) {
    final l10n = context.l10n;

    return BlocBuilder<
      SubscriptionResourceCubit,
      ResourceState<PRFMissionSubscription>
    >(
      builder: (context, state) {
        final subscriptions = context
            .read<SubscriptionResourceCubit>()
            .currentItems;

        final missions0 = subscriptions
            .map((subscription) => subscription.mission)
            .whereType<PRFMission>()
            .groupListsBy((mission) => mission.ulid)
            .values
            .map((missionGroup) => missionGroup.first)
            .toList();

        final missions = List<PRFMission>.from(missions0)
          ..sort((a, b) => b.startDate.compareTo(a.startDate));

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

              return TimelineMissionCard(
                    mission: mission,
                    isLast: isLast,
                    isSubscribed: true,
                    onTap: () => context.router.push(
                      MissionsDetailsRoute(
                        missionUlid: mission.ulid,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: index * 100),
                    duration: PRFMotionTokens.enterShort,
                  )
                  .slideX(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        );
      },
    );
  }

  Widget _buildPastMissionsTimeline(BuildContext context, int columns) {
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
              label: l10n.noMissions,
              description: state.maybeWhen(
                error: (message, _) => message,
                itemError: (message, _, _) => message,
                orElse: () => 'No past missions found.',
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

              return PRFSchoolCard(
                    schoolName: school.name,
                    address: school.address,
                    missionCount: missionCount > 0 ? missionCount : null,
                    onTap: () => context.router.push(
                      SchoolPastMissionsRoute(
                        schoolUlid: school.ulid,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: index * 100),
                    duration: PRFMotionTokens.enterShort,
                  )
                  .slideX(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        );
      },
    );
  }
}
