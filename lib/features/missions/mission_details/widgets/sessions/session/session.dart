import 'package:app/di/di_container.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/session/_handset.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/session/cubit/mission_session_details_resource_cubit.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SessionPage extends StatelessWidget {
  const SessionPage({
    @PathParam('missionSessionUlid') required this.missionSessionUlid,
    @PathParam('missionUlid') required this.missionUlid,
    @PathParam('missionSessionId') required this.missionSessionId,
    super.key,
  });

  final String missionSessionUlid;
  final String missionUlid;
  final int missionSessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MissionSessionDetailsResourceCubit>(
      create: (_) => MissionSessionDetailsResourceCubit(
        missionSessionService: getIt<MissionSessionService>(),
        dbService: getIt<IsarService>().missionSessions,
      )..loadSession(missionSessionUlid: missionSessionUlid),
      child: SessionPageHandset(
        missionSessionUlid: missionSessionUlid,
        missionUlid: missionUlid,
        missionSessionId: missionSessionId,
      ),
    );
  }
}
