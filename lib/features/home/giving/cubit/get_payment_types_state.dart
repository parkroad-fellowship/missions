part of 'get_payment_types_cubit.dart';

@freezed
class GetPaymentTypesState with _$GetPaymentTypesState {
  const factory GetPaymentTypesState.initial() = _Initial;
  const factory GetPaymentTypesState.loading() = _Loading;
  const factory GetPaymentTypesState.loaded({
    required List<PRFPaymentType> paymentTypes,
  }) = _Loaded;
  const factory GetPaymentTypesState.error(String error) = _Error;
}
