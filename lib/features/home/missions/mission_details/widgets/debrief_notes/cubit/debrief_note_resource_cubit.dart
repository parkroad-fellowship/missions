import 'package:app/models/local/mission/prf_debrief_note.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/models/remote/content/prf_debrief_note_dto.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/isar/debrief_note_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class DebriefNoteResourceCubit
    extends ResourceCubit<PRFDebriefNote, PRFLocalDebriefNote> {
  DebriefNoteResourceCubit({
    required DebriefNoteService debriefNoteService,
    super.dbService,
  }) : super(service: debriefNoteService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is DebriefNoteDbService) {
      await (dbService! as DebriefNoteDbService).refreshParentStream(parentKey);
    }
    await dbService?.refreshStream();
  }

  @override
  List<String> get defaultIncludes => ['mission'];

  /// Create a debrief note.
  Future<void> addDebriefNote({
    required String missionUlid,
    required String note,
  }) async {
    final dto = PRFDebriefNoteDTO(missionUlid: missionUlid, note: note);
    await create(data: dto.toJson());
  }

  /// Update a debrief note.
  Future<void> updateDebriefNote({
    required String ulid,
    required String missionUlid,
    required String note,
  }) async {
    final dto = PRFDebriefNoteDTO(missionUlid: missionUlid, note: note);
    await update(
      id: ulid,
      data: dto.toJson(),
      matchById: (n) => n.ulid == ulid,
    );
  }

  /// Delete a debrief note.
  Future<void> deleteDebriefNote(String ulid) async {
    await delete(ulid: ulid, matchById: (n) => n.ulid == ulid);
  }
}
