import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_ground_suggestion_dto.freezed.dart';
part 'prf_mission_ground_suggestion_dto.g.dart';

@freezed
abstract class PRFMissionGroundSuggestionDTO
    with _$PRFMissionGroundSuggestionDTO {
  factory PRFMissionGroundSuggestionDTO({
    required String name,
    @JsonKey(name: 'suggestor_ulid') required String suggestorUlid,
    @JsonKey(name: 'contact_person') required String contactPerson,
    @JsonKey(name: 'contact_number') required String contactNumber,
    String? notes,
    @Default(PRFMissionGroundSuggestionStatus.pending)
    PRFMissionGroundSuggestionStatus status,
  }) = _PRFMissionGroundSuggestionDTO;

  factory PRFMissionGroundSuggestionDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionGroundSuggestionDTOFromJson(json);
}
