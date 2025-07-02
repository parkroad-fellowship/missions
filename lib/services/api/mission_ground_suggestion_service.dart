import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/services/api/_base_api_service.dart';

class MissionGroundSuggestionService
    extends BaseAPIService<PRFMissionGroundSuggestion> {
  @override
  String get endpoint => '/mission-ground-suggestions';

  @override
  PRFMissionGroundSuggestion createFromJson(Map<String, dynamic> json) {
    return PRFMissionGroundSuggestion.fromJson(json);
  }

  @override
  List<PRFMissionGroundSuggestion> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFMissionGroundSuggestionResponse.fromJson(response).data;
  }
}
