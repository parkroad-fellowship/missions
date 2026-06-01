import 'dart:async';

import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class DebriefNoteHiveDbService extends BaseHiveDbService<PRFDebriefNote> {
  @override
  String get boxName => 'prf_debrief_notes';

  @override
  String getKey(PRFDebriefNote entity) => entity.ulid;

  @override
  PRFDebriefNote fromJson(Map<String, dynamic> json) =>
      PRFDebriefNote.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFDebriefNote entity) => entity.toJson();

  // ----- Parent (mission) stream -----

  Future<List<PRFDebriefNote>> listByMission(String missionUlid) =>
      filterBy((n) => n.mission?.ulid == missionUlid);

  Stream<List<PRFDebriefNote>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByMission(parentId));
}
