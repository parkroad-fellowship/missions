import 'dart:async';

import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/models/remote/content/prf_debrief_note_dto.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class DebriefNoteResourceCubit extends ResourceCubit<PRFDebriefNote> {
  DebriefNoteResourceCubit({
    required DebriefNoteService debriefNoteService,
    required HiveService hiveService,
  }) : super(service: debriefNoteService, dbService: hiveService.debriefNotes);

  @override
  Future<List<PRFDebriefNote>> loadCachedList({
    Map<String, dynamic>? filters,
  }) async {
    return dbService.filterBy(
      (debriefNote) => [
        filters?['mission_ulid'] == null ||
            debriefNote.mission?.ulid == filters!['mission_ulid'],
      ],
    );
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
