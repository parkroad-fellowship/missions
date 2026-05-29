import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session_dto.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/hive/db/mission_session_hive_db_service.dart';
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
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionSessionHiveDbService) {
      await (dbService as MissionSessionHiveDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService.refreshStream();
  }

  @override
  Future<PRFMissionSession?> loadCachedItem(String id) async {
    return dbService.get(id);
  }

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
}
