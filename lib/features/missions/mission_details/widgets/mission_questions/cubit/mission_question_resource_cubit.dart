import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/models/remote/mission/prf_mission_question_dto.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/hive/db/mission_question_hive_db_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionQuestionResourceCubit extends ResourceCubit<PRFMissionQuestion> {
  MissionQuestionResourceCubit({
    required MissionQuestionService missionQuestionService,
    required HiveService hiveService,
  }) : super(
         service: missionQuestionService,
         dbService: hiveService.missionQuestions,
       );

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionQuestionHiveDbService) {
      await (dbService as MissionQuestionHiveDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService.refreshStream();
  }

  @override
  List<String> get defaultIncludes => [
    'mission',
    'transcripts.media',
  ];

  /// Create a mission question.
  Future<void> addMissionQuestion({
    required String missionUlid,
    required String question,
  }) async {
    final dto = PRFMissionQuestionDTO(
      missionUlid: missionUlid,
      question: question,
    );
    await create(data: dto.toJson());
  }

  /// Update a mission question.
  Future<void> updateMissionQuestion({
    required String ulid,
    required String missionUlid,
    required String question,
  }) async {
    final dto = PRFMissionQuestionDTO(
      missionUlid: missionUlid,
      question: question,
    );
    await update(
      id: ulid,
      data: dto.toJson(),
      matchById: (q) => q.ulid == ulid,
    );
  }

  /// Delete a mission question.
  Future<void> deleteMissionQuestion(String ulid) async {
    await delete(ulid: ulid, matchById: (q) => q.ulid == ulid);
  }
}
