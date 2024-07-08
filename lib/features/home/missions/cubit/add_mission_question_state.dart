part of 'add_mission_question_cubit.dart';

@freezed
class AddMissionQuestionState with _$AddMissionQuestionState {
  const factory AddMissionQuestionState.initial() = _Initial;
  const factory AddMissionQuestionState.loading() = _Loading;
  const factory AddMissionQuestionState.loaded() = _Loaded;
  const factory AddMissionQuestionState.error(String message) = _Error;
}
