part of 'get_mission_session_cubit.dart';

@freezed
class GetMissionSessionState with _$GetMissionSessionState {
  const factory GetMissionSessionState.initial() = _Initial;
  const factory GetMissionSessionState.loading() = _Loading;
  const factory GetMissionSessionState.loaded({
    required PRFMissionSession missionSession,
  }) = _Loaded;
  const factory GetMissionSessionState.error(String message) = _Error;
}
