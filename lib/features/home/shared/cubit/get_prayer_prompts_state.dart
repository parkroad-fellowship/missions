part of 'get_prayer_prompts_cubit.dart';

@freezed
class GetPrayerPromptsState with _$GetPrayerPromptsState {
  const factory GetPrayerPromptsState.initial() = _Initial;
  const factory GetPrayerPromptsState.loading() = _Loading;
  const factory GetPrayerPromptsState.loaded() = _Loaded;
  const factory GetPrayerPromptsState.error(String message) = _Error;
}
