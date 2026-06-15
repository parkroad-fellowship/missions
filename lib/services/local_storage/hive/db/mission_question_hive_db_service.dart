import 'dart:async';

import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class MissionQuestionHiveDbService
    extends BaseHiveDbService<PRFMissionQuestion> {
  @override
  String get boxName => 'prf_mission_questions';

  @override
  String getKey(PRFMissionQuestion entity) => entity.ulid;

  @override
  PRFMissionQuestion fromJson(Map<String, dynamic> json) =>
      PRFMissionQuestion.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMissionQuestion entity) => entity.toJson();

  // ----- Parent (mission) stream -----

  Future<List<PRFMissionQuestion>> listByMission(String missionUlid) =>
      filterBy((q) => [q.mission?.ulid == missionUlid]);

  Stream<List<PRFMissionQuestion>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByMission(parentId));
}
