import 'package:app/models/local/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class MissionQuestionDbService
    extends BaseLocalDBService<PRFMissionQuestion, PRFLocalMissionQuestion> {
  MissionQuestionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMissionQuestion> get collection =>
      dbInstance.pRFLocalMissionQuestions;

  @override
  PRFLocalMissionQuestion remoteToLocal(PRFMissionQuestion remote) {
    return PRFLocalMissionQuestion(
      ulid: remote.ulid,
      question: remote.question,
      createdAt: remote.createdAt,
      missionUlid: remote.mission!.ulid,
    );
  }

  @override
  Stream<List<PRFLocalMissionQuestion>> getByParentKey(String parentKey) {
    return collection
        .where()
        .missionUlidEqualTo(parentKey)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
