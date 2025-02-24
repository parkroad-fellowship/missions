part of 'get_member_mission_subscriptions_cubit.dart';

@freezed
class GetMemberMissionSubscriptionsState
    with _$GetMemberMissionSubscriptionsState {
  const factory GetMemberMissionSubscriptionsState.initial() = _Initial;
  const factory GetMemberMissionSubscriptionsState.loading() = _Loading;
  const factory GetMemberMissionSubscriptionsState.loaded() = _Loaded;
  const factory GetMemberMissionSubscriptionsState.error(String message) =
      _Error;
}
