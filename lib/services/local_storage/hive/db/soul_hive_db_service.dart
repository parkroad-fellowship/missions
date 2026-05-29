import 'dart:async';

import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class SoulHiveDbService extends BaseHiveDbService<PRFSoul> {
  @override
  String get boxName => 'prf_souls';

  @override
  String getKey(PRFSoul entity) => entity.ulid;

  @override
  PRFSoul fromJson(Map<String, dynamic> json) => PRFSoul.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFSoul entity) => entity.toJson();

  // ----- Parent (mission) stream -----

  StreamController<List<PRFSoul>>? _parentStreamController;

  Stream<List<PRFSoul>> get parentStream {
    _parentStreamController ??= StreamController<List<PRFSoul>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<List<PRFSoul>> listByMission(String missionUlid) =>
      filterBy((s) => s.mission?.ulid == missionUlid);

  Future<void> refreshParentStream(String missionUlid) async {
    _parentStreamController ??= StreamController<List<PRFSoul>>.broadcast();
    _parentStreamController!.add(await listByMission(missionUlid));
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
