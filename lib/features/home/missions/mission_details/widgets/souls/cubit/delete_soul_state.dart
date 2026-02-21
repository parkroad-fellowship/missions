part of 'delete_soul_cubit.dart';

@freezed
class DeleteSoulState with _$DeleteSoulState {
  const factory DeleteSoulState.initial() = _Initial;
  const factory DeleteSoulState.loading() = _Loading;
  const factory DeleteSoulState.loaded() = _Loaded;
  const factory DeleteSoulState.error(String message) = _Error;
}
