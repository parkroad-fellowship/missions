import 'dart:convert';

import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_debrief_note.dart';
import 'package:app/models/prf_debrief_note_dto.dart';
import 'package:app/models/prf_soul.dart';
import 'package:app/models/prf_soul_dto.dart';
import 'package:app/utils/_index.dart';

abstract class DebriefService {
  Future<List<PRFDebriefNote>> getDebriefNotes({
    required String missionUlid,
  });
  Future<PRFDebriefNote> addDebriefNote({
    required PRFDebriefNoteDTO debriefNoteDTO,
  });
}

class DebriefServiceImpl implements DebriefService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFDebriefNote>> getDebriefNotes({
    required String missionUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/debrief-notes',
        queryParameters: {
          'filter[mission_ulid]': missionUlid,
        },
      );

      return PRFDebriefNoteResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFDebriefNote> addDebriefNote({
    required PRFDebriefNoteDTO debriefNoteDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/debrief-notes',
        body: json.encode(debriefNoteDTO.toJson()),
      );

      return PRFDebriefNote.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
