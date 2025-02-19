part of 'get_event_media_cubit.dart';

@freezed
class GetEventMediaState with _$GetEventMediaState {
  const factory GetEventMediaState.initial() = _Initial;
  const factory GetEventMediaState.loading() = _Loading;
  const factory GetEventMediaState.loaded({required List<PRFMedia> media}) = _Loaded;
  const factory GetEventMediaState.empty() = _Empty;
  const factory GetEventMediaState.error(String message) = _Error;
}
