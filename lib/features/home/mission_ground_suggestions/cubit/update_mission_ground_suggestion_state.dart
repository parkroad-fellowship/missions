part of 'update_mission_ground_suggestion_cubit.dart';

@freezed
class UpdateMissionGroundSuggestionState with _$UpdateMissionGroundSuggestionState {
  const factory UpdateMissionGroundSuggestionState.initial() = _Initial;
  const factory UpdateMissionGroundSuggestionState.loading() = _Loading;
  const factory UpdateMissionGroundSuggestionState.loaded({
    required PRFMissionGroundSuggestion missionGroundSuggestion,
  }) = _Loaded;
  const factory UpdateMissionGroundSuggestionState.error(String message) = _Error;
}
