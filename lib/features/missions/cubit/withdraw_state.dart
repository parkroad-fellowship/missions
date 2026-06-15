part of 'withdraw_cubit.dart';

@freezed
class WithdrawState with _$WithdrawState {
  const factory WithdrawState.initial() = _Initial;
  const factory WithdrawState.loading() = _Loading;
  const factory WithdrawState.loaded({
    required PRFMissionSubscription subscription,
  }) = _Loaded;
  const factory WithdrawState.error(String message) = _Error;
}
