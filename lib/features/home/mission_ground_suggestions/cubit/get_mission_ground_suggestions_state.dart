part of 'get_mission_ground_suggestions_cubit.dart';

@freezed
class GetMissionGroundSuggestionsState with _$GetMissionGroundSuggestionsState {
  const factory GetMissionGroundSuggestionsState.initial() = _Initial;
  const factory GetMissionGroundSuggestionsState.loading() = _Loading;
  const factory GetMissionGroundSuggestionsState.loaded({
    required List<PRFMissionGroundSuggestion> missionGroundSuggestions,
  }) = _Loaded;
  const factory GetMissionGroundSuggestionsState.empty() = _Empty;
  const factory GetMissionGroundSuggestionsState.error(String message) = _Error;
}
