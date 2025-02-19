part of 'delete_event_subscription_cubit.dart';

@freezed
class DeleteEventSubscriptionState with _$DeleteEventSubscriptionState {
  const factory DeleteEventSubscriptionState.initial() = _Initial;
  const factory DeleteEventSubscriptionState.loading() = _Loading;
  const factory DeleteEventSubscriptionState.loaded() = _Loaded;
  const factory DeleteEventSubscriptionState.error(String message) = _Error;
}
