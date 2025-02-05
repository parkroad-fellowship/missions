import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_ground_suggestion.freezed.dart';
part 'prf_mission_ground_suggestion.g.dart';

@freezed
class PRFMissionGroundSuggestion with _$PRFMissionGroundSuggestion {
  factory PRFMissionGroundSuggestion(
    String name,
    @JsonKey(name: 'suggestor_ulid') String suggestorUlid,
    @JsonKey(name: 'contact_person') String contactPerson,
    @JsonKey(name: 'contact_number') String contactNumber, {
    @Default(PRFMissionGroundSuggestionStatus.pending)
    PRFMissionGroundSuggestionStatus status,
  }) = _PRFMissionGroundSuggestion;

  factory PRFMissionGroundSuggestion.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionGroundSuggestionFromJson(json);
}

@freezed
class PRFMissionGroundSuggestionResponse
    with _$PRFMissionGroundSuggestionResponse {
  factory PRFMissionGroundSuggestionResponse(
    List<PRFMissionGroundSuggestion> data,
  ) = _PRFMissionGroundSuggestionResponse;

  factory PRFMissionGroundSuggestionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$PRFMissionGroundSuggestionResponseFromJson(json);
}
