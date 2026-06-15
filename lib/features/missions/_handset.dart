import 'package:app/di/di_container.dart';
import 'package:app/features/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/helpers/mission_helper.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  PRFMember? get member => getIt<HiveService>().retrieveMember();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _loadTabData(0, force: true); // initial tab

    _tabController.addListener(() {
      // Prevent duplicate calls during tab animation
      if (_tabController.indexIsChanging) return;

      final index = _tabController.index;
      if (index == _lastTabIndex) return;

      _lastTabIndex = index;
      _loadTabData(index);
    });

    _searchController.addListener(() {
      final newQuery = _searchController.text.trim();
      if (newQuery == _searchQuery) return;

      setState(() {
        _searchQuery = newQuery;
        _loadedTabs.clear(); // Clear loaded tabs to force reload with new query
      });

      // Reload current tab data with new search query
      _loadTabData(_tabController.index, force: true);
    });
  }

  int _lastTabIndex = 0;
  final Set<int> _loadedTabs = {};

  void _loadTabData(int index, {bool force = false}) {
    if (!force && _loadedTabs.contains(index)) return;

    switch (index) {
      case 0:
        context.read<MissionResourceCubit>().loadAll(
          filters: {
            if (_searchQuery.isNotEmpty) 'search': _searchQuery,
          },
        );
      case 1:
        context.read<MissionSubscriptionResourceCubit>().loadAll(
          filters: {
            'member_ulid': member?.ulid,
            if (_searchQuery.isNotEmpty) 'search': _searchQuery,
          },
        );
      case 2:
        context.read<PastMissionResourceCubit>().loadAll(
          filters: {
            if (_searchQuery.isNotEmpty) 'search': _searchQuery,
          },
        );
    }

    _loadedTabs.add(index);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                        MissionSubscriptionResourceCubit,
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
                            const Tab(text: 'Upcoming'),
                            Tab(text: l10n.subscribed),
                            const Tab(text: 'All Past'),
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
                    child: PRFTextInput(
                      hintText: l10n.missionsSearchHint,
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMissionsTimeline(context),
                  _buildSubscribedMissionsTimeline(context),
                  _buildPastMissionsTimeline(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsTimeline(BuildContext context) {
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
            onRefresh: () => context.read<MissionResourceCubit>().loadAll(),
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
          onRefresh: () => context.read<MissionResourceCubit>().loadAll(),
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
              return _buildTimelineMissionCard(
                    context,
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

  Widget _buildSubscribedMissionsTimeline(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      MissionSubscriptionResourceCubit,
      ResourceState<PRFMissionSubscription>
    >(
      builder: (context, state) {
        final subscriptions = context
            .read<MissionSubscriptionResourceCubit>()
            .currentItems;

        final missions = subscriptions
            .map((subscription) => subscription.mission)
            .whereType<PRFMission>()
            .groupListsBy((mission) => mission.ulid)
            .values
            .map((missionGroup) => missionGroup.first)
            .toList();

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
            onRefresh: () =>
                context.read<MissionSubscriptionResourceCubit>().loadAll(
                  filters: {
                    'member_ulid': member?.ulid,
                  },
                ),
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
          onRefresh: () =>
              context.read<MissionSubscriptionResourceCubit>().loadAll(
                filters: {
                  'member_ulid': member?.ulid,
                },
              ),
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

              return _buildTimelineMissionCard(
                    context,
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

  Widget _buildPastMissionsTimeline(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<PastMissionResourceCubit, ResourceState<PRFMission>>(
      builder: (context, state) {
        final missions = context.read<PastMissionResourceCubit>().currentItems;
        final showInitialLoader =
            state is ResourceListLoading<PRFMission> && missions.isEmpty;

        if (showInitialLoader) {
          return const Center(
            child: PRFCircularProgressIndicator(),
          );
        }

        if (missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<PastMissionResourceCubit>().loadAll(limit: 30),
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
          onRefresh: () =>
              context.read<PastMissionResourceCubit>().loadAll(limit: 30),
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

              return _buildTimelineMissionCard(
                    context,
                    mission: mission,
                    isLast: isLast,
                    onTap: () => context.router.push(
                      MissionsDetailsRoute(missionUlid: mission.ulid),
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

  Widget _buildTimelineMissionCard(
    BuildContext context, {
    required PRFMission mission,
    required bool isLast,
    required VoidCallback onTap,
    bool isSubscribed = false,
  }) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final startDate = mission.startDate;
    final endDate = mission.endDate;
    final isMultiDay = !MissionHelper.isSameDay(startDate, endDate);
    final now = DateTime.now();
    final isOngoing =
        (startDate.isBefore(now) || MissionHelper.isSameDay(startDate, now)) &&
        (endDate.isAfter(now) || MissionHelper.isSameDay(endDate, now));
    final durationDays = endDate.difference(startDate).inDays + 1;
    final timeRange =
        '${DateFormatter.formatTime(mission.startTime, timezone)} - ${DateFormatter.formatTime(mission.endTime, timezone)}';
    final datePrimaryText = isMultiDay
        ? '${DateFormatter.formatDate(startDate, timezone)} - ${DateFormatter.formatDate(endDate, timezone)}'
        : DateFormatter.formatDate(startDate, timezone);

    return PRFTimelineMissionCard(
      isLast: isLast,
      startDate: startDate,
      endDate: endDate,
      statusColor: _resolveMissionStatusColor(mission, theme),
      statusText: isSubscribed ? l10n.subscribed : mission.status.name,
      schoolName: mission.school?.name ?? '-',
      missionTypeName: mission.missionType?.name ?? '-',
      durationLabel: l10n.duration,
      durationValue: isMultiDay ? l10n.durationDesc(durationDays) : timeRange,
      capacityLabel: l10n.capacity,
      capacityValue: l10n.capacityDesc(mission.missionSubscriptionsNeeded),
      datePrimaryText: datePrimaryText,
      dateSecondaryText: timeRange,
      showActiveIndicator: isOngoing,
      activeIndicatorColor: theme.colorScheme.tertiary,
      actionLabel: l10n.missionDetails,
      onTap: onTap,
    );
  }

  Color _resolveMissionStatusColor(PRFMission mission, ThemeData theme) {
    switch (mission.status.apiKey) {
      case 1:
        return Colors.amber.shade700;
      case 2:
        return Colors.green.shade700;
      case 3:
        return theme.colorScheme.error;
      case 4:
        return Colors.red.shade700;
      case 5:
        return theme.colorScheme.primary;
      case 6:
        return theme.colorScheme.secondary;
      case 7:
        return Colors.deepOrange.shade500;
      default:
        return theme.colorScheme.primary;
    }
  }
}
