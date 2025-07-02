import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/services/_base_api_service.dart';

class MissionQuestionService extends BaseAPIService<PRFMissionQuestion> {
  @override
  String get endpoint => '/mission-questions';

  @override
  PRFMissionQuestion createFromJson(Map<String, dynamic> json) {
    return PRFMissionQuestion.fromJson(json);
  }

  @override
  List<PRFMissionQuestion> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFMissionQuestionResponse.fromJson(response).data;
  }
}
