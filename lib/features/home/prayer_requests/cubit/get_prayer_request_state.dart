part of 'get_prayer_request_cubit.dart';

@freezed
class GetPrayerRequestState with _$GetPrayerRequestState {
  const factory GetPrayerRequestState.initial() = _Initial;
  const factory GetPrayerRequestState.loading() = _Loading;
  const factory GetPrayerRequestState.loaded(
    List<PRFPrayerRequest> prayerRequests,
  ) = _Loaded;
  const factory GetPrayerRequestState.error(String message) = _Error;
}
