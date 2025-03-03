part of 'verify_transaction_cubit.dart';

@freezed
class VerifyTransactionState with _$VerifyTransactionState {
  const factory VerifyTransactionState.initial() = _Initial;
  const factory VerifyTransactionState.loading() = _Loading;
  const factory VerifyTransactionState.loaded() = _Loaded;
  const factory VerifyTransactionState.error(String message) = _Error;
}
