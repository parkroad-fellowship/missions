part of 'get_member_event_subscriptions_cubit.dart';

@freezed
class GetMemberEventSubscriptionsState with _$GetMemberEventSubscriptionsState {
  const factory GetMemberEventSubscriptionsState.initial() = _Initial;
  const factory GetMemberEventSubscriptionsState.loading() = _Loading;
  const factory GetMemberEventSubscriptionsState.loaded({
    required List<PRFEventSubscription> subscriptions,
  }) = _Loaded;
  const factory GetMemberEventSubscriptionsState.empty() = _Empty;
  const factory GetMemberEventSubscriptionsState.error(String message) = _Error;
}
