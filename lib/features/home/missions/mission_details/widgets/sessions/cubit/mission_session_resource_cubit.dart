import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSessionResourceCubit extends ResourceCubit<PRFMissionSession> {
  MissionSessionResourceCubit({
    required MissionSessionService missionSessionService,
    super.dbService,
  }) : super(service: missionSessionService);

  @override
  List<String> get defaultIncludes => [
    'facilitator',
    'speaker',
    'classGroup',
    'missionSessionTranscripts.media',
    'mission',
  ];

  /// Create a mission session.
  Future<void> addSession({required Map<String, dynamic> data}) async {
    await create(data: data);
  }

  /// Update a mission session.
  Future<void> updateSession({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete a mission session.
  Future<void> deleteSession(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }
}
