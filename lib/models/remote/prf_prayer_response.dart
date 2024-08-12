import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_prayer_response.freezed.dart';
part 'prf_prayer_response.g.dart';

@freezed
class PRFPrayerResponse with _$PRFPrayerResponse {
  factory PRFPrayerResponse(
    String entity,
    String ulid, {
    @JsonKey(name: 'prayer_prompt') PRFPrayerPrompt? prayerPrompt,
  }) = _PRFPrayerResponse;

  factory PRFPrayerResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerResponseFromJson(json);
}

@freezed
class PRFPrayerResponseDTO with _$PRFPrayerResponseDTO {
  factory PRFPrayerResponseDTO({
    @JsonKey(name: 'prayer_prompt_ulid') required String prayerPromptUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
  }) = _PRFPrayerResponseDTO;

  factory PRFPrayerResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerResponseDTOFromJson(json);
}
