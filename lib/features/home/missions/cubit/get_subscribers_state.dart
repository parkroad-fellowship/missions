part of 'get_subscribers_cubit.dart';

@freezed
class GetSubscribersState with _$GetSubscribersState {
  const factory GetSubscribersState.initial() = _Initial;
  const factory GetSubscribersState.loading() = _Loading;
  const factory GetSubscribersState.loaded({
    required List<PRFMissionSubscription> subscriptions,
  }) = _Loaded;
  const factory GetSubscribersState.error(String message) = _Error;
}
