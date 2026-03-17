import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class MissionsPageTablet extends StatefulWidget {
  const MissionsPageTablet({super.key});

  @override
  State<MissionsPageTablet> createState() => _MissionsPageTabletState();
}

class _MissionsPageTabletState extends State<MissionsPageTablet>
    with SingleTickerProviderStateMixin {
  Stream<List<PRFLocalMission>> get _missionsStream =>
      getIt<IsarService>().missions.stream;

  Stream<List<PRFLocalMission>> get _memberMissionsStream =>
      getIt<IsarService>().memberMissions.parentStream;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    context.read<GetMissionsCubit>().getMissions(refresh: true);
    context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions(
      refresh: true,
    );

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<GetMissionsCubit>().getMissions();
      } else {
        context.read<GetMemberMissionSubscriptionsCubit>().getSubscriptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.missions,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          leading: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              boxShadow: [
                BoxShadow(
                  color: PRFColors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(left: PRFSpacingTokens.lg),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
              onPressed: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
            ),
          ),
          actions: [
            BlocBuilder<GetMissionsCubit, GetMissionsState>(
              builder: (context, state) => state.maybeWhen(
                loading: () => const SizedBox.square(
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
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.all),
              Tab(text: l10n.subscribed),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMissionsTimeline(context),
            _buildSubscribedMissionsTimeline(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsTimeline(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return StreamBuilder<List<PRFLocalMission>>(
      key: PageStorageKey('missions_stream_${_tabController.index}'),
      stream: _missionsStream,
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
        Logger().e(missions);

        if (missions != null && missions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<GetMissionsCubit>().getMissions(),
            child: PRFEmptyView(
              label: l10n.noMissions,
              description: l10n.pleaseWait,
            ),
          );
        }

        // Sort missions by start date for timeline
        final sortedMissions = List<PRFLocalMission>.from(missions!)
          ..sort((a, b) => a.startDate.compareTo(b.startDate));

        return RefreshIndicator(
          onRefresh: () => context.read<GetMissionsCubit>().getMissions(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.xl,
              vertical: PRFSpacingTokens.xxl,
            ),
            itemCount: sortedMissions.length,
            itemBuilder: (context, index) {
              final mission = sortedMissions[index];
              final isLast = index == sortedMissions.length - 1;

              return TimelineMissionCardTablet(
                    mission: mission,
                    isLast: isLast,
                    index: index,
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
        Logger().e(missions);

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
              horizontal: PRFSpacingTokens.xl,
              vertical: PRFSpacingTokens.xxl,
            ),
            itemCount: missions!.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isLast = index == missions.length - 1;

              return TimelineMissionCardTablet(
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

class TimelineMissionCardTablet extends StatelessWidget with TimezoneMixin {
  const TimelineMissionCardTablet({
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
    final l10n = context.l10n;
    final now = DateTime.now();
    final startDate = mission.startDate;
    final endDate = mission.endDate;
    final isUpcoming = startDate.isAfter(now);
    final isPast = endDate.isBefore(now.subtract(const Duration(days: 1)));
    final isOngoing = startDate.isBefore(now) && endDate.isAfter(now);
    final isMultiDay = !_isSameDay(startDate, endDate);
    final duration = endDate.difference(startDate).inDays + 1;

    // Premium status color system
    final statusColor = isSubscribed
        ? PRFColors.limeGreen
        : isOngoing
        ? PRFColors
              .limeGreen // Active green
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Column(
            children: [
              // Multi-day date badge
              Container(
                width: 70,
                height: isMultiDay ? 180 : 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMultiDay) ...[
                      // Start date
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 2,
                        color: Colors.white.withValues(alpha: 0.7),
                        margin: const EdgeInsets.symmetric(
                          vertical: PRFSpacingTokens.xs,
                        ),
                      ),
                      // End date
                      Text(
                        endDate.day.toString(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(endDate.month),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else ...[
                      // Single day
                      Text(
                        startDate.day.toString(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormatter.getMonthAbbreviation(startDate.month),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Timeline line with flexible height
              if (!isLast)
                Container(
                  width: 3,
                  height: 80,
                  margin: const EdgeInsets.symmetric(
                    vertical: PRFSpacingTokens.lg,
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
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: PRFSpacingTokens.xl),

        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.05),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Premium header with gradient
                    Container(
                      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
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
                          // School name and status
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  mission.school!.name!,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.md),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.md,
                                  vertical: PRFSpacingTokens.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.md,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  statusText,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Mission type with icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(
                                    PRFRadiusTokens.smd,
                                  ),
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 20,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.md),
                              Expanded(
                                child: Text(
                                  mission.missionType!.name!,
                                  style: theme.textTheme.titleMedium?.copyWith(
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

                    // Content section
                    Padding(
                      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Duration and timing info
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
                                      : '${DateFormatter.formatTime(mission.startTime, timezone)} - ${DateFormatter.formatTime(mission.endTime, timezone)}',
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.md),
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  Icons.people_rounded,
                                  l10n.capacity,
                                  l10n.capacityDesc(mission.capacity),
                                  theme.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: PRFSpacingTokens.md),
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  Icons.people_rounded,
                                  l10n.missionariesNeeded,
                                  l10n.subscriptionsNeeded(
                                    mission.missionSubscriptionsNeeded
                                        .toString(),
                                  ),
                                  theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Date range display
                          Container(
                            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.md,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: PRFSpacingTokens.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isMultiDay
                                            // ignore: lines_longer_than_80_chars
                                            ? '${DateFormatter.formatDate(startDate, timezone)} - ${DateFormatter.formatDate(endDate, timezone)}'
                                            : DateFormatter.formatDate(
                                                startDate,
                                                timezone,
                                              ),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isMultiDay)
                                        Text(
                                          // ignore: lines_longer_than_80_chars
                                          '${DateFormatter.formatTime(mission.startTime, timezone)} - ${DateFormatter.formatTime(mission.endTime, timezone)}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                // Progress indicator for ongoing missions
                                if (isOngoing)
                                  Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: context.statusColors.active,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: context
                                                  .statusColors
                                                  .activeGlow,
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(),
                                      )
                                      .scale(
                                        begin: const Offset(0.8, 0.8),
                                        end: const Offset(1.2, 1.2),
                                        duration: 1000.ms,
                                      ),
                              ],
                            ),
                          ),

                          const SizedBox(height: PRFSpacingTokens.lg),

                          // Action button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.xl,
                              vertical: PRFSpacingTokens.md,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
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
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.sm),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
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
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
