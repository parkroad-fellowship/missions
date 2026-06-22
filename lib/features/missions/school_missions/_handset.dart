import 'package:app/features/missions/cubit/school_details_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/helpers/mission_helper.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SchoolMissionsHandset extends StatefulWidget {
  const SchoolMissionsHandset({required this.schoolUlid, super.key});

  final String schoolUlid;

  @override
  State<SchoolMissionsHandset> createState() => _SchoolMissionsHandsetState();
}

class _SchoolMissionsHandsetState extends State<SchoolMissionsHandset>
    with TimezoneMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<SchoolDetailsResourceCubit, ResourceState<PRFSchool>>(
        builder: (context, state) {
          return state.maybeWhen(
            itemLoading: (_, item) {
              if (item != null) return _buildPage(context, item);
              return const Center(child: PRFCircularProgressIndicator());
            },
            itemLoaded: (school, _) => _buildPage(context, school),
            itemError: (message, _, school) {
              if (school != null) return _buildPage(context, school);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: PRFSpacingTokens.md),
                      FilledButton(
                        onPressed: () {
                          context.read<SchoolDetailsResourceCubit>().loadSchool(
                            schoolUlid: widget.schoolUlid,
                            refresh: true,
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, PRFSchool school) {
    final missions = List<PRFMission>.from(school.missions)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Column(
      children: [
        PRFBrandedNavBar(
          title: school.name,
          onBack: () => context.router.maybePop(),
        ),
        Expanded(
          child: missions.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: () async {
                    await context.read<SchoolDetailsResourceCubit>().loadSchool(
                      schoolUlid: widget.schoolUlid,
                      refresh: true,
                    );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.sm,
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.xl,
                    ),
                    children: [
                      _buildSchoolHeader(context, school),
                      const SizedBox(height: PRFSpacingTokens.md),
                      ...missions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final mission = entry.value;
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
                      }),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: PRFEmptyView(
        label: l10n.noMissions,
        description: 'No past missions for this school.',
      ),
    );
  }

  Widget _buildSchoolHeader(BuildContext context, PRFSchool school) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    school.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: PRFSpacingTokens.xs),
                      Expanded(
                        child: Text(
                          school.address,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
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
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        Row(
          children: [
            _buildInfoChip(
              theme,
              icon: Icons.people_rounded,
              label: '${school.totalStudents} students',
            ),
            const SizedBox(width: PRFSpacingTokens.sm),
            _buildInfoChip(
              theme,
              icon: Icons.flag_rounded,
              label: '${school.missions.length} missions',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    ThemeData theme, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMissionCard(
    BuildContext context, {
    required PRFMission mission,
    required bool isLast,
    required VoidCallback onTap,
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
      statusText: mission.status.name,
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
