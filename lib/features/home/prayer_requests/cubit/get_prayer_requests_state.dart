part of 'get_prayer_requests_cubit.dart';

@freezed
class GetPrayerRequestsState with _$GetPrayerRequestsState {
  const factory GetPrayerRequestsState.initial() = _Initial;
  const factory GetPrayerRequestsState.loading() = _Loading;
  const factory GetPrayerRequestsState.loaded({
    @Default([]) List<PRFPrayerRequest> prayerRequests,
  }) = _Loaded;
  const factory GetPrayerRequestsState.error(String message) = _Error;
}
