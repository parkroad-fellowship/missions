part of 'select_media_cubit.dart';

@freezed
class SelectMediaState with _$SelectMediaState {
  const factory SelectMediaState.initial() = _Initial;
  const factory SelectMediaState.loaded({required List<PRFImageDTO> media}) =
      _Loaded;
}
