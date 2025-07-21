import 'package:app/models/local/prf_debrief_note.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class DebriefNoteDbService
    extends BaseLocalDBService<PRFDebriefNote, PRFLocalDebriefNote> {
  DebriefNoteDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalDebriefNote> get collection =>
      dbInstance.pRFLocalDebriefNotes;

  @override
  PRFLocalDebriefNote remoteToLocal(PRFDebriefNote remote) {
    return PRFLocalDebriefNote(
      ulid: remote.ulid,
      note: remote.note,
      createdAt: remote.createdAt,
      missionUlid: remote.mission!.ulid,
    );
  }

  @override
  Stream<List<PRFLocalDebriefNote>> getByParentKey(String parentKey) {
    return collection
        .where()
        .missionUlidEqualTo(parentKey)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
