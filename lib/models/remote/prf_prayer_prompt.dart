import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_prayer_prompt.freezed.dart';
part 'prf_prayer_prompt.g.dart';

@freezed
class PRFPrayerPrompt with _$PRFPrayerPrompt {
  factory PRFPrayerPrompt(
    String entity,
    String ulid,
    String description,
    int frequency, {
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'time_of_day') required int timeOfDay,
    @JsonKey(name: 'prayer_responses') List<PRFPrayerResponse>? prayerResponses,
  }) = _PRFPrayerPrompt;

  factory PRFPrayerPrompt.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerPromptFromJson(json);
}

@freezed
class PRFPrayerPromptResponse with _$PRFPrayerPromptResponse {
  factory PRFPrayerPromptResponse(
    List<PRFPrayerPrompt> data,
  ) = _PRFPrayerPromptResponse;

  factory PRFPrayerPromptResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerPromptResponseFromJson(json);
}
