part of 'add_soul_cubit.dart';

@freezed
class AddSoulState with _$AddSoulState {
  const factory AddSoulState.initial() = _Initial;
  const factory AddSoulState.loading() = _Loading;
  const factory AddSoulState.loaded({
    required PRFSoul soul,
  }) = _Loaded;
  const factory AddSoulState.error(String message) = _Error;
}
