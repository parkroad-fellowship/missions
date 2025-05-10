part of 'add_prayer_request_cubit.dart';

@freezed
class AddPrayerRequestState with _$AddPrayerRequestState {
  const factory AddPrayerRequestState.initial() = _Initial;
  const factory AddPrayerRequestState.loading() = _Loading;
  const factory AddPrayerRequestState.loaded({
    @Default([]) List<PRFPrayerRequest> prayerRequests,
  }) = _Loaded;
  const factory AddPrayerRequestState.error(String message) = _Error;
}
