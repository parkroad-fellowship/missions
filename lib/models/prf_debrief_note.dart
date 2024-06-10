import 'package:app/models/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_debrief_note.freezed.dart';
part 'prf_debrief_note.g.dart';

@freezed
class PRFDebriefNote with _$PRFDebriefNote {
  factory PRFDebriefNote(
    String ulid,
    String note,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMission? mission,
  }) = _PRFDebriefNote;

  factory PRFDebriefNote.fromJson(Map<String, dynamic> json) =>
      _$PRFDebriefNoteFromJson(json);
}

@freezed
class PRFDebriefNoteResponse with _$PRFDebriefNoteResponse {
  const factory PRFDebriefNoteResponse({
    required List<PRFDebriefNote> data,
  }) = _PRFDebriefNoteResponse;

  factory PRFDebriefNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFDebriefNoteResponseFromJson(json);
}
