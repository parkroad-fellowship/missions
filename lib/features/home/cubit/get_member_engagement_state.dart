part of 'get_member_engagement_cubit.dart';

@freezed
class GetMemberEngagementState with _$GetMemberEngagementState {
  const factory GetMemberEngagementState.initial() = _Initial;
  const factory GetMemberEngagementState.loading() = _Loading;
  const factory GetMemberEngagementState.loaded({
    required PRFMemberEngagement memberEngagement,
  }) = _Loaded;
  const factory GetMemberEngagementState.empty() = _Empty;
  const factory GetMemberEngagementState.error(String message) = _Error;
}
