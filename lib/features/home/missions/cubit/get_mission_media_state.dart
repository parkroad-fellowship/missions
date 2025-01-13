part of 'get_mission_media_cubit.dart';

@freezed
class GetMissionMediaState with _$GetMissionMediaState {
  const factory GetMissionMediaState.initial() = _Initial;
  const factory GetMissionMediaState.loading() = _Loading;
  const factory GetMissionMediaState.loaded({required List<PRFMedia> media}) =
      _Loaded;
  const factory GetMissionMediaState.empty() = _Empty;
  const factory GetMissionMediaState.error(String message) = _Error;
}
