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

  Future<List<PRFSoul>> listByMission(String missionUlid) =>
      filterBy((s) => s.mission?.ulid == missionUlid);

  Stream<List<PRFSoul>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByMission(parentId));
}
