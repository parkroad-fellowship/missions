part of 'update_mission_session_cubit.dart';

@freezed
class UpdateMissionSessionState with _$UpdateMissionSessionState {
  const factory UpdateMissionSessionState.initial() = _Initial;
  const factory UpdateMissionSessionState.loading() = _Loading;
  const factory UpdateMissionSessionState.loaded({
    required PRFMissionSession missionSession,
  }) = _Loaded;
  const factory UpdateMissionSessionState.error(String error) = _Error;
}
