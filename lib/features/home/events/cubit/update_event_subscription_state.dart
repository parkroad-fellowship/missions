part of 'update_event_subscription_cubit.dart';

@freezed
class UpdateEventSubscriptionState with _$UpdateEventSubscriptionState {
  const factory UpdateEventSubscriptionState.initial() = _Initial;
  const factory UpdateEventSubscriptionState.loading() = _Loading;
  const factory UpdateEventSubscriptionState.loaded({
    required PRFEventSubscription subscription,
  }) = _Loaded;
  const factory UpdateEventSubscriptionState.error(String message) = _Error;
}
