import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart' as col;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SessionsViewHandset extends StatefulWidget {
  const SessionsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SessionsViewHandset> createState() => _SessionsViewHandsetState();
}

class _SessionsViewHandsetState extends State<SessionsViewHandset>
    with TimezoneMixin {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<MissionSessionResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.sm),
      child:
          BlocBuilder<
            MissionSessionResourceCubit,
            ResourceState<PRFMissionSession>
          >(
            builder: (context, state) {
              return state.maybeWhen(
                listLoading: () => const Center(
                  child: PRFCircularProgressIndicator(),
                ),
                listLoaded: (sessions, _, _) {
                  if (sessions.isEmpty) {
                    return PRFEmptyView(
                      label: l10n.noSessions,
                      description: l10n.sessionsWillAppearHere,
                      icon: Icons.event_note_outlined,
                    );
                  }

                  // Group by startsAt date
                  final missionSessions = col.groupBy(
                    sessions,
                    (session) => session.startsAt,
                  );

                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: missionSessions.length,
                    itemBuilder: (context, index) {
                      final sortedDailySessions = List<PRFMissionSession>.from(
                        missionSessions.values.elementAt(index),
                      )..sort((a, b) => a.startsAt.compareTo(b.startsAt));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline Date Header
                          Container(
                                margin: const EdgeInsets.only(
                                  left: PRFSpacingTokens.xxl,
                                  top: PRFSpacingTokens.lg,
                                  bottom: PRFSpacingTokens.sm,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.md),
                                    Text(
                                      DateFormatter.formatMissionDate(
                                        missionSessions.keys.elementAt(index),
                                        timezone,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                              .animate(delay: (index * 100).ms)
                              .slideX(begin: -0.3)
                              .fadeIn(),

                          // Timeline Sessions
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: sortedDailySessions.length,
                            itemBuilder: (context, i) => TimelineSessionCard(
                              missionSession: sortedDailySessions[i],
                              missionUlid: missionUlid,
                              isLast: i == sortedDailySessions.length - 1,
                              animationDelay: (index * 100 + i * 50).ms,
                              userTimezone: timezone,
                            ),
                          ),
                          const SizedBox(height: PRFSpacingTokens.lg),
                        ],
                      );
                    },
                  );
                },
                error: (message, _) => PRFEmptyView(
                  label: l10n.noSessions,
                  description: message,
                  icon: Icons.event_note_outlined,
                ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
    );
  }
}

class TimelineSessionCard extends StatelessWidget {
  const TimelineSessionCard({
    required this.missionSession,
    required this.missionUlid,
    required this.isLast,
    required this.animationDelay,
    required this.userTimezone,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;
  final bool isLast;
  final Duration animationDelay;
  final String userTimezone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(
        left: PRFSpacingTokens.lg,
        right: PRFSpacingTokens.lg,
        bottom: PRFSpacingTokens.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                ),
            ],
          ),
          const SizedBox(width: PRFSpacingTokens.lg),

          // Session Card
          Expanded(
            child: GestureDetector(
              onTap: () => context.router.push(
                SessionRoute(
                  missionSessionUlid: missionSession.ulid,
                  missionUlid: missionUlid,
                  missionSessionId: 0,
                ),
              ),
              child:
                  Container(
                        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.smd,
                          ),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.shadow.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.sm,
                                    vertical: PRFSpacingTokens.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                    borderRadius: BorderRadius.circular(
                                      PRFRadiusTokens.sm,
                                    ),
                                  ),
                                  child: Text(
                                    // ignore: lines_longer_than_80_chars
                                    '${DateFormatter.formatTimeFromDateTime(missionSession.startsAt, userTimezone)} - ${DateFormatter.formatTimeFromDateTime(missionSession.endsAt, userTimezone)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                ),
                                const SizedBox(width: PRFSpacingTokens.xs),
                                Text(
                                  '${l10n.facilitator}: ',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Expanded(
                                  child: Text(
                                    missionSession.facilitator?.fullName ??
                                        'N/A',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (missionSession.speaker != null) ...[
                              const SizedBox(height: PRFSpacingTokens.xs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.mic_outlined,
                                    size: 16,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                  ),
                                  const SizedBox(width: PRFSpacingTokens.xs),
                                  Text(
                                    '${l10n.speaker}: ',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      missionSession.speaker?.fullName ?? 'N/A',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (missionSession.classGroup != null) ...[
                              const SizedBox(height: PRFSpacingTokens.xs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.group_outlined,
                                    size: 16,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                  ),
                                  const SizedBox(width: PRFSpacingTokens.xs),
                                  Text(
                                    '${l10n.classGroup}: ',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      missionSession.classGroup?.name ?? 'N/A',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )
                      .animate(delay: animationDelay)
                      .slideX(begin: 0.3)
                      .fadeIn(duration: PRFMotionTokens.slow)
                      .scale(begin: const Offset(0.95, 0.95)),
            ),
          ),
        ],
      ),
    );
  }
}
