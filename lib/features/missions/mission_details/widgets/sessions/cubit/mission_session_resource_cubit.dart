import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session_dto.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSessionResourceCubit extends ResourceCubit<PRFMissionSession> {
  MissionSessionResourceCubit({
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

  /// Create a mission session.
  Future<void> addSession({required PRFMissionSessionDTO data}) async {
    await create(data: data.toJson());
  }

  /// Update a mission session.
  Future<void> updateSession({
    required String ulid,
    required PRFMissionSessionDTO data,
  }) async {
    await update(
      id: ulid,
      data: data.toJson(),
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete a mission session.
  Future<void> deleteSession(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }

  @override
  Future<List<PRFMissionSession>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
