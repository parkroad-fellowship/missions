import 'package:app/di/di_container.dart';
import 'package:app/features/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/subscriptions_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/helpers/mission_helper.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionsFormState {
  MissionsFormState();

  late final VoidCallback _rebuild;

  final searchController = TextEditingController();
  final _searchDebouncer = Debouncer(milliseconds: 300);
  String searchQuery = '';

  int lastTabIndex = 0;
  final Set<int> loadedTabs = {};

  /// Whether the card entrance cascade has played for this screen instance;
  /// later rebuilds (search keystrokes, tab loads) skip it.
  bool entrancePlayed = false;

  PRFMember? get member => getIt<HiveService>().retrieveMember();

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  void initListeners(TabController tabController, BuildContext context) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;

      final index = tabController.index;
      if (index == lastTabIndex) return;

      lastTabIndex = index;
      loadTabData(index, context);
    });

    searchController.addListener(() {
      final newQuery = searchController.text.trim();
      if (newQuery == searchQuery) return;

      searchQuery = newQuery;
      loadedTabs.clear(); // Force reload with new search query
      _rebuild();

      _searchDebouncer.run(() {
        loadTabData(tabController.index, context, force: true);
      });
    });
  }

  Future<void> loadTabData(
    int index,
    BuildContext context, {
    bool force = false,
  }) async {
    if (!force && loadedTabs.contains(index)) return;

    switch (index) {
      case 0:
        await context.read<MissionResourceCubit>().loadAll(
          filters: {
            if (searchQuery.isNotEmpty) 'search': searchQuery,
          },
        );
      case 1:
        await context.read<SubscriptionResourceCubit>().loadAll(
          filters: {
            'member_ulid': member?.ulid,
            if (searchQuery.isNotEmpty) 'search': searchQuery,
          },
        );
      case 2:
        await context.read<PastMissionResourceCubit>().loadAll(
          filters: {
            if (searchQuery.isNotEmpty) 'search': searchQuery,
          },
        );
    }

    loadedTabs.add(index);
  }

  void dispose() {
    _searchDebouncer.cancel();
    searchController.dispose();
  }
}

/// Status accent colours remapped to brand tokens, each guaranteed readable
/// under the white text used by the timeline badges (lime is never a status:
/// it is reserved for action moments only).
Color resolveMissionStatusColor(PRFMission mission, ThemeData theme) {
  Color aaSafe(Color base) => Color.lerp(base, Colors.black, 0.22)!;

  return switch (mission.status.apiKey) {
    1 => aaSafe(PRFColors.warning),
    2 => aaSafe(PRFColors.emerald),
    3 => theme.colorScheme.error,
    4 => aaSafe(const Color(0xFFD32F2F)),
    5 => theme.colorScheme.primary,
    6 => PRFColors.emerald,
    7 => aaSafe(PRFColors.orange),
    _ => theme.colorScheme.primary,
  };
}

/// Entrance animation for timeline entries: plays once per screen instance,
/// respects the system reduce-motion setting, and caps the stagger so cards
/// scrolled into view appear immediately rather than waiting out a
/// per-index delay.
Widget buildAnimatedTimelineEntry({
  required BuildContext context,
  required int index,
  required bool animate,
  required Widget child,
}) {
  if (!animate || MediaQuery.disableAnimationsOf(context)) {
    return child;
  }

  final cappedIndex = index % 8;

  return child
      .animate()
      .fadeIn(
        delay: Duration(milliseconds: cappedIndex * 60),
        duration: PRFMotionTokens.enterShort,
      )
      .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic);
}

class TimelineMissionCard extends StatelessWidget with TimezoneMixin {
  const TimelineMissionCard({
    required this.mission,
    required this.isLast,
    required this.onTap,
    this.isSubscribed = false,
    super.key,
  });

  final PRFMission mission;
  final bool isLast;
  final VoidCallback onTap;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
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
      statusColor: resolveMissionStatusColor(mission, theme),
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
}
