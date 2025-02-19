part of 'add_event_subscription_cubit.dart';

@freezed
class AddEventSubscriptionState with _$AddEventSubscriptionState {
  const factory AddEventSubscriptionState.initial() = _Initial;
  const factory AddEventSubscriptionState.loading() = _Loading;
  const factory AddEventSubscriptionState.loaded({
    required PRFEventSubscription subscription,
  }) = _Loaded;
  const factory AddEventSubscriptionState.error(String message) = _Error;
}
