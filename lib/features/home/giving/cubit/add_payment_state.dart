part of 'add_payment_cubit.dart';

@freezed
class AddPaymentState with _$AddPaymentState {
  const factory AddPaymentState.initial() = _Initial;
  const factory AddPaymentState.loading() = _Loading;
  const factory AddPaymentState.loaded({required PRFPayment payment}) = _Loaded;
  const factory AddPaymentState.error(String error) = _Error;
}
