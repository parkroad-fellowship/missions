import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    l10n.noSubscribers,
                    style: CustomTextTheme.customTextTheme()
                        .headlineSmall!
                        .copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.appTheme().kPrimaryColorV2,
                        ),
                  ),
                ),
            loaded: (missionSessions) => ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: missionSessions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) =>
                      MissionSessionCard(missionSession: missionSessions[index]),
                ));
      },
    );
  }
}

class MissionSessionCard extends StatelessWidget {
  const MissionSessionCard({
    required this.missionSession,
    super.key,
  });

  final PRFMissionSession missionSession;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [
        SaturateEffect(),
      ],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 60.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.appTheme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionSession.startsAt.toIso8601String(),
                  style:
                      CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
                ),
                SizedBox(height: 16.h),
                Text(missionSession.notes),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
