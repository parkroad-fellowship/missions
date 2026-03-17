import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final Stream<List<PRFLocalMission>> _memberMissionsStream;

  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Initialize member missions stream (still Isar-based)
    _memberMissionsStream = getIt<IsarService>().memberMissions.parentStream;

    context.read<MissionResourceCubit>().loadAll();
    context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions(
      refresh: true,
    );

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<MissionResourceCubit>().loadAll();
      } else {
        context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
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
                          listLoading: () => const SizedBox.square(
                            dimension: 24,
                            child: PRFCircularProgressIndicator(),
                          ),
                          orElse: SizedBox.shrink,
                        ),
                      ),
                      const SizedBox(width: PRFSpacingTokens.sm),
                      BlocBuilder<
                        GetMemberMissionSubscriptionsCubit,
                        GetMemberMissionSubscriptionsState
                      >(
                        builder: (context, state) => state.maybeWhen(
                          loading: () => const SizedBox.square(
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
                            Tab(text: l10n.all),
                            Tab(text: l10n.subscribed),
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
                  _buildMissionsTimeline(context),
                  _buildSubscribedMissionsTimeline(context),
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
        return state.maybeWhen(
          listLoading: () => const Center(
            child: PRFCircularProgressIndicator(),
          ),
          listLoaded: (missions, _, _) {
            if (missions.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<MissionResourceCubit>().loadAll(),
                child: PRFEmptyView(
                  label: l10n.noMissions,
                  description: l10n.pleaseWait,
                ),
              );
            }

            final sortedMissions = List<PRFMission>.from(missions)
              ..sort((a, b) => a.startDate.compareTo(b.startDate));

            return RefreshIndicator(
              onRefresh: () => context.read<MissionResourceCubit>().loadAll(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.lg,
                  vertical: PRFSpacingTokens.xl,
                ),
                itemCount: sortedMissions.length,
                itemBuilder: (context, index) {
                  final mission = sortedMissions[index];
                  final isLast = index == sortedMissions.length - 1;

                  return TimelineMissionCard(
                        mission: mission,
                        isLast: isLast,
                        index: index,
                        onTap: () => context.router
                            .push(
                              MissionsDetailsRoute(
                                missionUlid: mission.ulid,
                              ),
                            )
                            .then((_) {
                              // ignore: use_build_context_synchronously
                              context.read<MissionResourceCubit>().loadAll();
                              // ignore: use_build_context_synchronously
                              context
                                  .read<GetMemberMissionSubscriptionsCubit>()
                                  .getSubscriptions();
                            }),
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
          error: (message, _) => RefreshIndicator(
            onRefresh: () => context.read<MissionResourceCubit>().loadAll(),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: message,
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildSubscribedMissionsTimeline(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return StreamBuilder<List<PRFLocalMission>>(
      key: PageStorageKey(
        'member_missions_stream_${_tabController.index}',
      ),
      stream: _memberMissionsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          );
        }

        final missions = snapshot.data;

        if (missions != null && missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => context
                .read<GetMemberMissionSubscriptionsCubit>()
                .getSubscriptions(),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: l10n.pleaseWait,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context
              .read<GetMemberMissionSubscriptionsCubit>()
              .getSubscriptions(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.xl,
            ),
            itemCount: missions!.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isLast = index == missions.length - 1;

              return TimelineMissionCardLocal(
                    mission: mission,
                    isLast: isLast,
                    index: index,
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
}

/// Timeline card using remote PRFMission model (for "All" tab via BlocBuilder).
class TimelineMissionCard extends StatelessWidget with TimezoneMixin {
  const TimelineMissionCard({
    required this.mission,
    required this.isLast,
    required this.index,
    this.isSubscribed = false,
    this.onTap,
    super.key,
  });

  final PRFMission mission;
  final bool isLast;
  final int index;
  final bool isSubscribed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final now = DateTime.now();
    final startDate = mission.startDate;
    final endDate = mission.endDate;
    final isUpcoming = startDate.isAfter(now);
    final isPast = endDate.isBefore(now.subtract(const Duration(days: 1)));
    final isOngoing = startDate.isBefore(now) && endDate.isAfter(now);
    final isMultiDay = !_isSameDay(startDate, endDate);
    final duration = endDate.difference(startDate).inDays + 1;

    final statusColor = isSubscribed
        ? PRFColors.limeGreen
        : isOngoing
        ? PRFColors.limeGreen
        : isUpcoming
        ? theme.colorScheme.primary
        : isPast
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.secondary;

    final statusText = isSubscribed
        ? 'Subscribed'
        : isOngoing
        ? 'Active'
        : isUpcoming
        ? 'Upcoming'
        : isPast
        ? 'Completed'
        : 'Available';

    return _buildCard(
      context,
      theme: theme,
      l10n: l10n,
      startDate: startDate,
      endDate: endDate,
      isMultiDay: isMultiDay,
      isOngoing: isOngoing,
      duration: duration,
      statusColor: statusColor,
      statusText: statusText,
      schoolName: mission.school?.name ?? '',
      missionTypeName: mission.missionType?.name ?? '',
      startTime: mission.startTime,
      endTime: mission.endTime,
      capacity: mission.capacity,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required ThemeData theme,
    required dynamic l10n,
    required DateTime startDate,
    required DateTime endDate,
    required bool isMultiDay,
    required bool isOngoing,
    required int duration,
    required Color statusColor,
    required String statusText,
    required String schoolName,
    required String missionTypeName,
    required String startTime,
    required String endTime,
    required int capacity,
  }) {
    return _TimelineCardBody(
      isLast: isLast,
      isMultiDay: isMultiDay,
      startDate: startDate,
      endDate: endDate,
      statusColor: statusColor,
      statusText: statusText,
      schoolName: schoolName,
      missionTypeName: missionTypeName,
      startTime: startTime,
      endTime: endTime,
      capacity: capacity,
      duration: duration,
      isOngoing: isOngoing,
      timezone: timezone,
      onTap: onTap,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Timeline card using local PRFLocalMission model (for "Subscribed" tab).
class TimelineMissionCardLocal extends StatelessWidget with TimezoneMixin {
  const TimelineMissionCardLocal({
    required this.mission,
    required this.isLast,
    required this.index,
    this.isSubscribed = false,
    this.onTap,
    super.key,
  });

  final PRFLocalMission mission;
  final bool isLast;
  final int index;
  final bool isSubscribed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final startDate = mission.startDate;
    final endDate = mission.endDate;
    final isUpcoming = startDate.isAfter(now);
    final isPast = endDate.isBefore(now.subtract(const Duration(days: 1)));
    final isOngoing = startDate.isBefore(now) && endDate.isAfter(now);
    final isMultiDay = !_isSameDay(startDate, endDate);
    final duration = endDate.difference(startDate).inDays + 1;

    final statusColor = isSubscribed
        ? PRFColors.limeGreen
        : isOngoing
        ? PRFColors.limeGreen
        : isUpcoming
        ? theme.colorScheme.primary
        : isPast
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.secondary;

    final statusText = isSubscribed
        ? 'Subscribed'
        : isOngoing
        ? 'Active'
        : isUpcoming
        ? 'Upcoming'
        : isPast
        ? 'Completed'
        : 'Available';

    return _TimelineCardBody(
      isLast: isLast,
      isMultiDay: isMultiDay,
      startDate: startDate,
      endDate: endDate,
      statusColor: statusColor,
      statusText: statusText,
      schoolName: mission.school?.name ?? '',
      missionTypeName: mission.missionType?.name ?? '',
      startTime: mission.startTime,
      endTime: mission.endTime,
      capacity: mission.capacity,
      duration: duration,
      isOngoing: isOngoing,
      timezone: timezone,
      onTap: onTap,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Shared card body widget used by both remote and local timeline cards.
class _TimelineCardBody extends StatelessWidget {
  const _TimelineCardBody({
    required this.isLast,
    required this.isMultiDay,
    required this.startDate,
    required this.endDate,
    required this.statusColor,
    required this.statusText,
    required this.schoolName,
    required this.missionTypeName,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.duration,
    required this.isOngoing,
    required this.timezone,
    this.onTap,
  });

  final bool isLast;
  final bool isMultiDay;
  final DateTime startDate;
  final DateTime endDate;
  final Color statusColor;
  final String statusText;
  final String schoolName;
  final String missionTypeName;
  final String startTime;
  final String endTime;
  final int capacity;
  final int duration;
  final bool isOngoing;
  final String timezone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Column(
            children: [
              Container(
                width: 50,
                height: isMultiDay ? 100 : 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMultiDay) ...[
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.7),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        endDate.day.toString(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(endDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else ...[
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    vertical: PRFSpacingTokens.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        statusColor.withValues(alpha: 0.6),
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: PRFSpacingTokens.lg),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            statusColor.withValues(alpha: 0.1),
                            statusColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  schoolName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.sm,
                                  vertical: PRFSpacingTokens.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  statusText,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: PRFSpacingTokens.md),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.sm,
                                  ),
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Expanded(
                                child: Text(
                                  missionTypeName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  Icons.access_time_rounded,
                                  l10n.duration,
                                  isMultiDay
                                      ? l10n.durationDesc(duration)
                                      // ignore: lines_longer_than_80_chars
                                      : '${DateFormatter.formatTime(startTime, timezone)} - ${DateFormatter.formatTime(endTime, timezone)}',
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.sm),
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  Icons.people_rounded,
                                  l10n.capacity,
                                  l10n.capacityDesc(capacity),
                                  theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: PRFSpacingTokens.md),
                          _DateRangeViewGeneric(
                            isMultiDay: isMultiDay,
                            startDate: startDate,
                            timezone: timezone,
                            endDate: endDate,
                            startTime: startTime,
                            endTime: endTime,
                            isOngoing: isOngoing,
                          ),
                          const SizedBox(height: PRFSpacingTokens.md),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                              vertical: PRFSpacingTokens.sm,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.sm,
                              ),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Details',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.xs),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: statusColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: PRFSpacingTokens.xs),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DateRangeViewGeneric extends StatelessWidget {
  const _DateRangeViewGeneric({
    required this.isMultiDay,
    required this.startDate,
    required this.timezone,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isOngoing,
  });

  final bool isMultiDay;
  final DateTime startDate;
  final String timezone;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: PRFSpacingTokens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMultiDay
                      // ignore: lines_longer_than_80_chars
                      ? '${DateFormatter.formatDate(startDate, timezone)} - ${DateFormatter.formatDate(endDate, timezone)}'
                      : DateFormatter.formatDate(startDate, timezone),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isMultiDay)
                  Text(
                    // ignore: lines_longer_than_80_chars
                    '${DateFormatter.formatTime(startTime, timezone)} - ${DateFormatter.formatTime(endTime, timezone)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (isOngoing)
            Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.statusColors.active,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.statusColors.activeGlow,
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 1000.ms,
                ),
        ],
      ),
    );
  }
}
