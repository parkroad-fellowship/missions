import 'dart:async';

import 'package:app/models/local/mission/prf_debrief_note.dart';
import 'package:app/models/remote/content/prf_debrief_note.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

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
  PRFDebriefNote localToRemote(PRFLocalDebriefNote local) {
    return PRFDebriefNote(
      local.ulid,
      local.note,
      local.createdAt,
      local.createdAt,
    );
  }

  Future<List<PRFLocalDebriefNote>> listParentNotes(
    String parentKey,
  ) async {
    return collection.where().missionUlidEqualTo(parentKey).findAll();
  }

  StreamController<List<PRFLocalDebriefNote>>? _parentStreamController;
  Stream<List<PRFLocalDebriefNote>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalDebriefNote>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalDebriefNote>>.broadcast();
    final entities = await listParentNotes(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
