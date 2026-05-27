part of 'subscribe_cubit.dart';

@freezed
class SubscribeState with _$SubscribeState {
  const factory SubscribeState.initial() = _Initial;
  const factory SubscribeState.loading() = _Loading;
  const factory SubscribeState.loaded({
    required PRFMissionSubscription subscription,
  }) = _Loaded;
  const factory SubscribeState.error(String message) = _Error;
}
