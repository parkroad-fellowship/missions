import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/services/api/_base_api_service.dart';

class DebriefNoteService extends BaseAPIService<PRFDebriefNote> {
  @override
  String get endpoint => '/debrief-notes';

  @override
  PRFDebriefNote createFromJson(Map<String, dynamic> json) {
    return PRFDebriefNote.fromJson(json);
  }

  @override
  List<PRFDebriefNote> createListFromResponse(Map<String, dynamic> response) {
    return PRFDebriefNoteResponse.fromJson(response).data;
  }
}
