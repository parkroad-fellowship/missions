part of 'update_mission_question_cubit.dart';

@freezed
class UpdateMissionQuestionState with _$UpdateMissionQuestionState {
  const factory UpdateMissionQuestionState.initial() = _Initial;
  const factory UpdateMissionQuestionState.loading() = _Loading;
  const factory UpdateMissionQuestionState.loaded() = _Loaded;
  const factory UpdateMissionQuestionState.error(String message) = _Error;
}
