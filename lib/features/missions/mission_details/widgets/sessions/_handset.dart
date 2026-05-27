import 'package:app/features/missions/mission_details/widgets/sessions/actions/session_form/session_form.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
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

  Future<void> _showAddSessionSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.addSession,
      child: SessionFormView(missionUlid: missionUlid),
    );
  }

  Future<void> _showEditSessionSheet(PRFMissionSession missionSession) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: SessionFormView(
        missionUlid: missionUlid,
        missionSession: missionSession,
      ),
    );
  }

  Future<void> _deleteSession(PRFMissionSession missionSession) async {
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${context.l10n.delete} ${context.l10n.sessions}',
      message: 'Are you sure you want to continue?',
      confirmLabel: context.l10n.delete,
      isDestructive: true,
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<MissionSessionResourceCubit>().deleteSession(
      missionSession.ulid,
    );
    if (!mounted) return;

    final error = context.read<MissionSessionResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );
    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }
    PRFSnackbar.success(context, 'Session deleted');
  }

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
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.sm,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.md,
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
          child: FilledButton.icon(
            onPressed: _showAddSessionSheet,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.addSession),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.sm,
            ),
            child:
                BlocBuilder<
                  MissionSessionResourceCubit,
                  ResourceState<PRFMissionSession>
                >(
                  builder: (context, state) {
                    return state.maybeWhen(
                      listLoading: (_) => const Center(
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

                        final missionSessions = col.groupBy(
                          sessions,
                          (session) => session.startsAt,
                        );

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: missionSessions.length,
                          itemBuilder: (context, index) {
                            final sortedDailySessions =
                                List<PRFMissionSession>.from(
                                  missionSessions.values.elementAt(index),
                                )..sort(
                                  (a, b) => a.startsAt.compareTo(b.startsAt),
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                              color: theme.colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: PRFSpacingTokens.md,
                                          ),
                                          Text(
                                            DateFormatter.formatMissionDate(
                                              missionSessions.keys.elementAt(
                                                index,
                                              ),
                                              timezone,
                                            ),
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .animate(delay: (index * 100).ms)
                                    .slideX(begin: -0.3)
                                    .fadeIn(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedDailySessions.length,
                                  itemBuilder: (context, i) =>
                                      TimelineSessionCard(
                                        missionSession: sortedDailySessions[i],
                                        missionUlid: missionUlid,
                                        isLast:
                                            i == sortedDailySessions.length - 1,
                                        animationDelay:
                                            (index * 100 + i * 50).ms,
                                        userTimezone: timezone,
                                        onEdit: () => _showEditSessionSheet(
                                          sortedDailySessions[i],
                                        ),
                                        onDelete: () => _deleteSession(
                                          sortedDailySessions[i],
                                        ),
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
          ),
        ),
      ],
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
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;
  final bool isLast;
  final Duration animationDelay;
  final String userTimezone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
                            ).colorScheme.outline.withValues(alpha: 0.38),
                          ),
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Tooltip(
                                      message: context.l10n.edit,
                                      child: GestureDetector(
                                        onTap: onEdit,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: PRFSpacingTokens.sm,
                                            vertical: PRFSpacingTokens.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.11),
                                            borderRadius: BorderRadius.circular(
                                              PRFRadiusTokens.full,
                                            ),
                                          ),
                                          child: Text(
                                            context.l10n.edit,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Tooltip(
                                      message: context.l10n.delete,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                        ),
                                        onPressed: onDelete,
                                      ),
                                    ),
                                  ],
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
