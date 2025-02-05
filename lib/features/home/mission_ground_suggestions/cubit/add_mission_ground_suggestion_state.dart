part of 'add_mission_ground_suggestion_cubit.dart';

@freezed
class AddMissionGroundSuggestionState with _$AddMissionGroundSuggestionState {
  const factory AddMissionGroundSuggestionState.initial() = _Initial;
  const factory AddMissionGroundSuggestionState.loading() = _Loading;
  const factory AddMissionGroundSuggestionState.loaded({
    required PRFMissionGroundSuggestion missionGroundSuggestion,
  }) = _Loaded;
  const factory AddMissionGroundSuggestionState.error(String message) = _Error;
}
