import 'dart:async';

import 'package:app/models/local/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

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

  Future<List<PRFLocalMissionQuestion>> listParentMissionQuestions(
    String parentKey,
  ) async {
    return collection.where().missionUlidEqualTo(parentKey).findAll();
  }

  StreamController<List<PRFLocalMissionQuestion>>? _parentStreamController;
  Stream<List<PRFLocalMissionQuestion>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionQuestion>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionQuestion>>.broadcast();
    final entities = await listParentMissionQuestions(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
