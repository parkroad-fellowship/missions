part of 'prayer_request_cubit.dart';

@freezed
class PrayerRequestState with _$PrayerRequestState {
  const factory PrayerRequestState.initial() = _Initial;
  const factory PrayerRequestState.loading() = _Loading;
  const factory PrayerRequestState.loaded({
    required List<PRFPrayerRequest> prayerRequests,
  }) = _Loaded;
  const factory PrayerRequestState.error(String message) = _Error;
}
