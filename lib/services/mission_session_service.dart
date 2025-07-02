import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/services/_base_api_service.dart';

class MissionSessionService extends BaseAPIService<PRFMissionSession> {
  @override
  String get endpoint => '/mission-sessions';

  @override
  PRFMissionSession createFromJson(Map<String, dynamic> json) {
    return PRFMissionSession.fromJson(json);
  }

  @override
  List<PRFMissionSession> createListFromResponse(Map<String, dynamic> response) {
    return PRFMissionSessionsResponse.fromJson(response).data;
  }
}
