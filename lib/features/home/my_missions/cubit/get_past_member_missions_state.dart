part of 'get_past_member_missions_cubit.dart';

@freezed
class GetPastMemberMissionsState with _$GetPastMemberMissionsState {
  const factory GetPastMemberMissionsState.initial() = _Initial;
  const factory GetPastMemberMissionsState.loading() = _Loading;
  const factory GetPastMemberMissionsState.loaded({
    required List<PRFMissionSubscription> missionSubscriptions,
  }) = _Loaded;
  const factory GetPastMemberMissionsState.error(String message) = _Error;
}
