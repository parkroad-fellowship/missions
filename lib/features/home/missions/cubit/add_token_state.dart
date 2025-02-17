part of 'add_token_cubit.dart';

@freezed
class AddTokenState with _$AddTokenState {
  const factory AddTokenState.initial() = _Initial;
  const factory AddTokenState.loading() = _Loading;
  const factory AddTokenState.loaded() = _Loaded;
  const factory AddTokenState.error(String message) = _Error;
}
