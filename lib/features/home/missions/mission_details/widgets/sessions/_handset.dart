import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SessionsViewHandset extends StatefulWidget {
  const SessionsViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<SessionsViewHandset> createState() => _SessionsViewHandsetState();
}

class _SessionsViewHandsetState extends State<SessionsViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context
        .read<GetMissionSessionsCubit>()
        .getMissionSessions(missionUlid: missionUlid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetMissionSessionsCubit, GetMissionSessionsState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          empty: () => Center(
            child: Text(
              l10n.noSessions,
              style: PRFText.theme().headlineSmall!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PRFApp.theme().kPrimaryColorV2,
                  ),
            ),
          ),
          loaded: (missionSessions) => ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: missionSessions.length,
            itemBuilder: (context, index) {
              final sortedDailySessions = List<PRFMissionSession>.from(
                missionSessions.values.elementAt(index),
              )..sort((a, b) => a.startsAt.compareTo(b.startsAt));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat.MMMMEEEEd()
                            .format(missionSessions.keys.elementAt(index)),
                        style: PRFText.theme().headlineSmall!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: PRFApp.theme().kBlackColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: sortedDailySessions.length,
                    itemBuilder: (context, i) => Column(
                      children: [
                        MissionSessionCard(
                          missionSession: sortedDailySessions[i],
                          missionUlid: missionUlid,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class MissionSessionCard extends StatelessWidget {
  const MissionSessionCard({
    required this.missionSession,
    required this.missionUlid,
    super.key,
  });

  final PRFMissionSession missionSession;
  final String missionUlid;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Animate(
      effects: const [SaturateEffect()],
      child: GestureDetector(
        onTap: () => context.router.push(
          SessionRoute(
            missionSession: missionSession,
            missionUlid: missionUlid,
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 60.h,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(48.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat.jm().format(missionSession.startsAt)} -'
                        ' ${DateFormat.jm().format(missionSession.endsAt)}',
                        style: PRFText.theme().titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.facilitator}: '
                        '${missionSession.facilitator!.fullName}\n'
                        '${l10n.speaker}: '
                        '${missionSession.speaker?.fullName}',
                        style: PRFText.theme().bodySmall!.copyWith(
                              color: PRFApp.theme().kBlackColor,
                              fontSize: 14,
                            ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
