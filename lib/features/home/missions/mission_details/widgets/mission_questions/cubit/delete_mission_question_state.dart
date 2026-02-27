part of 'delete_mission_question_cubit.dart';

@freezed
class DeleteMissionQuestionState with _$DeleteMissionQuestionState {
  const factory DeleteMissionQuestionState.initial() = _Initial;
  const factory DeleteMissionQuestionState.loading() = _Loading;
  const factory DeleteMissionQuestionState.loaded() = _Loaded;
  const factory DeleteMissionQuestionState.error(String message) = _Error;
}
