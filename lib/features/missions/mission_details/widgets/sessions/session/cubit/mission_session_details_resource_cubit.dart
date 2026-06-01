import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart'
    show MissionSessionResourceCubit;
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/hive/db/mission_session_hive_db_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

/// Dedicated cubit for mission session detail screens.
///
/// Detail loading stays isolated from [MissionSessionResourceCubit], which is
/// used by list and mutation flows in the mission sessions tab.
class MissionSessionDetailsResourceCubit
    extends SingleResourceCubit<PRFMissionSession> {
  MissionSessionDetailsResourceCubit({
    required MissionSessionService missionSessionService,
    required HiveService hiveService,
  }) : super(
         service: missionSessionService,
         dbService: hiveService.missionSessions,
       );

  @override
  List<String> get defaultIncludes => [
    'facilitator',
    'speaker',
    'classGroup',
    'transcripts.media',
    'mission',
  ];

  Future<void> loadSession({
    required String missionSessionUlid,
    bool refresh = false,
  }) async {
    await loadOne(
      id: missionSessionUlid,
      refresh: refresh,
      matchById: (session) => session.ulid == missionSessionUlid,
    );
  }
}
