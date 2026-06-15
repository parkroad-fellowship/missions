import 'dart:async';

import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class MissionSessionHiveDbService extends BaseHiveDbService<PRFMissionSession> {
  @override
  String get boxName => 'prf_mission_sessions';

  @override
  String getKey(PRFMissionSession entity) => entity.ulid;

  @override
  PRFMissionSession fromJson(Map<String, dynamic> json) =>
      PRFMissionSession.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMissionSession entity) => entity.toJson();

  // ----- Parent (mission) stream -----

  Future<List<PRFMissionSession>> listByMission(String missionUlid) =>
      filterBy((s) => [s.mission?.ulid == missionUlid]);

  Stream<List<PRFMissionSession>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByMission(parentId));
}
