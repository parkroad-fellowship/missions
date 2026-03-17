import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class DebriefNoteResourceCubit extends ResourceCubit<PRFDebriefNote> {
  DebriefNoteResourceCubit({
    required DebriefNoteService debriefNoteService,
    super.dbService,
  }) : super(service: debriefNoteService);

  @override
  List<String> get defaultIncludes => ['mission'];

  /// Create a debrief note.
  Future<void> addDebriefNote({required Map<String, dynamic> data}) async {
    await create(data: data);
  }

  /// Update a debrief note.
  Future<void> updateDebriefNote({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (n) => n.ulid == ulid,
    );
  }

  /// Delete a debrief note.
  Future<void> deleteDebriefNote(String ulid) async {
    await delete(ulid: ulid, matchById: (n) => n.ulid == ulid);
  }
}
