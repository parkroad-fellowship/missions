import 'dart:convert';

import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_debrief_note_dto.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_question_dto.dart';
import 'package:app/utils/_index.dart';

abstract class DebriefService {
  Future<List<PRFDebriefNote>> getDebriefNotes({required String missionUlid});
  Future<PRFDebriefNote> addDebriefNote({
    required PRFDebriefNoteDTO debriefNoteDTO,
  });
  Future<List<PRFMissionQuestion>> getMissionQuestions({
    required String missionUlid,
  });
  Future<PRFMissionQuestion> addMissionQuestion({
    required PRFMissionQuestionDTO missionQuestionDTO,
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
        queryParameters: {'filter[mission_ulid]': missionUlid},
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

  @override
  Future<List<PRFMissionQuestion>> getMissionQuestions({
    required String missionUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-questions',
        queryParameters: {'filter[mission_ulid]': missionUlid},
      );

      return PRFMissionQuestionResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFMissionQuestion> addMissionQuestion({
    required PRFMissionQuestionDTO missionQuestionDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/mission-questions',
        body: json.encode(missionQuestionDTO.toJson()),
      );

      return PRFMissionQuestion.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
