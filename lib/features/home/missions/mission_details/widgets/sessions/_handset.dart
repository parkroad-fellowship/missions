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
              style: CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
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
            itemBuilder: (context, index) => Column(
              children: [
                MissionSessionCard(missionSession: missionSessions[index]),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
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
    final l10n = context.l10n;
    return Animate(
      effects: const [
        SaturateEffect(),
      ],
      child: DataTable(
        columns: [
          _createDataColumn(DateFormat.EEEE().format(missionSession.startsAt)),
          _createDataColumn(l10n.info),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(_createText(l10n.time)),
              DataCell(
                _createText(
                  "${DateFormat.Hm().format(missionSession.startsAt)} -"
                  " ${DateFormat.Hm().format(missionSession.endsAt)}",
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(_createText(l10n.facilitator)),
              DataCell(_createText(missionSession.facilitator!.fullName)),
            ],
          ),
          if (missionSession.speaker != null)
            DataRow(
              cells: [
                DataCell(_createText(l10n.speaker)),
                DataCell(_createText(missionSession.speaker!.fullName)),
              ],
            ),
          if (missionSession.classGroup != null)
            DataRow(
              cells: [
                DataCell(_createText(l10n.classGroup)),
                DataCell(_createText(missionSession.classGroup!.name)),
              ],
            ),
          DataRow(
            cells: [
              DataCell(_createText(l10n.notes)),
              DataCell(
                Text(
                  missionSession.notes,
                  overflow: TextOverflow.visible,
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.appTheme().kBlackColor,
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

DataColumn _createDataColumn(String label) {
  return DataColumn(
    label: Text(
      label,
      style: CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.appTheme().kBlackColor,
          ),
    ),
  );
}

Text _createText(String text) {
  return Text(
    text,
    style: CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.appTheme().kBlackColor,
        ),
  );
}
