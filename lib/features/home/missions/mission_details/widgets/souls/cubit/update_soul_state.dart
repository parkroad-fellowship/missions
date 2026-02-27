part of 'update_soul_cubit.dart';

@freezed
class UpdateSoulState with _$UpdateSoulState {
  const factory UpdateSoulState.initial() = _Initial;
  const factory UpdateSoulState.loading() = _Loading;
  const factory UpdateSoulState.loaded() = _Loaded;
  const factory UpdateSoulState.error(String message) = _Error;
}
