part of 'get_payments_cubit.dart';

@freezed
class GetPaymentsState with _$GetPaymentsState {
  const factory GetPaymentsState.initial() = _Initial;
  const factory GetPaymentsState.loading() = _Loading;
  const factory GetPaymentsState.loaded({
    required List<PRFPayment> payments,
  }) = _Loaded;
  const factory GetPaymentsState.empty() = _Empty;
  const factory GetPaymentsState.error(String error) = _Error;
}
