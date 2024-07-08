part of 'get_mission_questions_cubit.dart';

@freezed
class GetMissionQuestionsState with _$GetMissionQuestionsState {
  const factory GetMissionQuestionsState.initial() = _Initial;
  const factory GetMissionQuestionsState.loading() = _Loading;
  const factory GetMissionQuestionsState.loaded({
    required List<PRFMissionQuestion> missionQuestions,
  }) = _Loaded;
  const factory GetMissionQuestionsState.error(String message) = _Error;
}
