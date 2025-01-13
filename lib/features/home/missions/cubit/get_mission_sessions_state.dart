part of 'get_mission_sessions_cubit.dart';

@freezed
class GetMissionSessionsState with _$GetMissionSessionsState {
  const factory GetMissionSessionsState.initial() = _Initial;
  const factory GetMissionSessionsState.loading() = _Loading;
  const factory GetMissionSessionsState.loaded({
    required Map<DateTime, List<PRFMissionSession>> groupedSessions,
  }) = _Loaded;
  const factory GetMissionSessionsState.empty() = _Empty;
  const factory GetMissionSessionsState.error(String error) = _Error;
}
