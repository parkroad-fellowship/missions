part of 'add_mission_session_cubit.dart';

@freezed
class AddMissionSessionState with _$AddMissionSessionState {
  const factory AddMissionSessionState.initial() = _Initial;
  const factory AddMissionSessionState.loading() = _Loading;
  const factory AddMissionSessionState.loaded() = _Loaded;
  const factory AddMissionSessionState.error(String error) = _Error;
}
