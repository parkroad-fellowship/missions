import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_transcript.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_question.freezed.dart';
part 'prf_mission_question.g.dart';

@freezed
abstract class PRFMissionQuestion with _$PRFMissionQuestion {
  factory PRFMissionQuestion(
    String ulid,
    String question,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMission? mission,
    @JsonKey(name: 'question_media_answers')
    @Default([])
    List<PRFMedia> questionMediaAnswers,
    @Default([]) List<PRFTranscript> transcripts,
  }) = _PRFMissionQuestion;

  factory PRFMissionQuestion.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionQuestionFromJson(json);
}

@freezed
abstract class PRFMissionQuestionResponse with _$PRFMissionQuestionResponse {
  factory PRFMissionQuestionResponse({required List<PRFMissionQuestion> data}) =
      _PRFMissionQuestionResponse;

  factory PRFMissionQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionQuestionResponseFromJson(json);
}
