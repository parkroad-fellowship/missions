import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/isar/mission_question_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionQuestionResourceCubit extends ResourceCubit<PRFMissionQuestion> {
  MissionQuestionResourceCubit({
    required MissionQuestionService missionQuestionService,
    super.dbService,
  }) : super(service: missionQuestionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionQuestionDbService) {
      await (dbService as MissionQuestionDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService?.refreshStream();
  }

  @override
  List<String> get defaultIncludes => ['mission'];

  /// Create a mission question.
  Future<void> addMissionQuestion({required Map<String, dynamic> data}) async {
    await create(data: data);
  }

  /// Update a mission question.
  Future<void> updateMissionQuestion({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (q) => q.ulid == ulid,
    );
  }

  /// Delete a mission question.
  Future<void> deleteMissionQuestion(String ulid) async {
    await delete(ulid: ulid, matchById: (q) => q.ulid == ulid);
  }
}
