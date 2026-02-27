part of 'delete_media_cubit.dart';

@freezed
class DeleteMediaState with _$DeleteMediaState {
  const factory DeleteMediaState.initial() = _Initial;
  const factory DeleteMediaState.loading() = _Loading;
  const factory DeleteMediaState.loaded() = _Loaded;
  const factory DeleteMediaState.error(String message) = _Error;
}
