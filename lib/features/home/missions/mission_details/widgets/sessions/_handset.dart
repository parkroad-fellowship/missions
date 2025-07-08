import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_mission_session.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<GetMissionSessionsCubit>().getMissionSessions(
      missionUlid: missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleStreamWrapper(
      stream: getIt<LocalDBService>().getMissionSessions(
        missionUlid: missionUlid,
      ),
      nullWidget: Center(
        child:
            Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noSessions,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8)),
      ),
      widget: (context, missionSessions) => ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: missionSessions.length,
        itemBuilder: (context, index) {
          final sortedDailySessions = List<PRFLocalMissionSession>.from(
            missionSessions.values.elementAt(index),
          )..sort((a, b) => a.startsAt.compareTo(b.startsAt));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Date Header
              Container(
                margin: const EdgeInsets.only(left: 32, top: 16, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Misc.formatMissionDate(
                        missionSessions.keys.elementAt(index),
                        timezone,
                      ),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ).animate(delay: (index * 100).ms).slideX(begin: -0.3).fadeIn(),

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
              const SizedBox(height: 16),
            ],
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

  final PRFLocalMissionSession missionSession;
  final String missionUlid;
  final bool isLast;
  final Duration animationDelay;
  final String userTimezone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
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
          const SizedBox(width: 16),

          // Session Card
          Expanded(
            child: GestureDetector(
              onTap: () => context.router.push(
                SessionRoute(
                  missionSessionUlid: missionSession.ulid,
                  missionUlid: missionUlid,
                  missionSessionId: missionSession.id,
                ),
              ),
              child:
                  Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
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
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${Misc.formatTimeFromDateTime(missionSession.startsAt, userTimezone)} - ${Misc.formatTimeFromDateTime(missionSession.endsAt, userTimezone)}',
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
                            const SizedBox(height: 12),
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
                                const SizedBox(width: 6),
                                Text(
                                  '${l10n.facilitator}: ',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Expanded(
                                  child: Text(
                                    missionSession.facilitator.fullName ??
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
                              const SizedBox(height: 4),
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
                                  const SizedBox(width: 6),
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
                              const SizedBox(height: 4),
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
                                  const SizedBox(width: 6),
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
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.95, 0.95)),
            ),
          ),
        ],
      ),
    );
  }
}
