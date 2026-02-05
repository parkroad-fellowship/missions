part of 'get_souls_cubit.dart';

@freezed
class GetSoulsState with _$GetSoulsState {
  const factory GetSoulsState.initial() = _Initial;
  const factory GetSoulsState.loading() = _Loading;
  const factory GetSoulsState.loaded() = _Loaded;
  const factory GetSoulsState.error(String message) = _Error;
}
