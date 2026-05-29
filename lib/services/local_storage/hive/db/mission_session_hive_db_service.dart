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

  StreamController<List<PRFMissionSession>>? _parentStreamController;

  Stream<List<PRFMissionSession>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFMissionSession>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<List<PRFMissionSession>> listByMission(String missionUlid) =>
      filterBy((s) => s.mission?.ulid == missionUlid);

  Future<void> refreshParentStream(String missionUlid) async {
    _parentStreamController ??=
        StreamController<List<PRFMissionSession>>.broadcast();
    _parentStreamController!.add(await listByMission(missionUlid));
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
