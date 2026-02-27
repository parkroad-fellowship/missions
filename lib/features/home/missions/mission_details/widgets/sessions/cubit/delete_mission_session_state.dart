part of 'delete_mission_session_cubit.dart';

@freezed
class DeleteMissionSessionState with _$DeleteMissionSessionState {
  const factory DeleteMissionSessionState.initial() = _Initial;
  const factory DeleteMissionSessionState.loading() = _Loading;
  const factory DeleteMissionSessionState.loaded() = _Loaded;
  const factory DeleteMissionSessionState.error(String message) = _Error;
}
