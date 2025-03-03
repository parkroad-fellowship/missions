import 'package:app/models/remote/failure.dart';
import 'package:app/services/payment_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_transaction_state.dart';
part 'verify_transaction_cubit.freezed.dart';

class VerifyTransactionCubit extends Cubit<VerifyTransactionState> {
  VerifyTransactionCubit({required PaymentService paymentService})
    : super(VerifyTransactionState.initial()) {
    _paymentService = paymentService;
  }

  late PaymentService _paymentService;

  Future<void> verifyTransaction({required String paymentUlid}) async {
    emit(VerifyTransactionState.loading());
    try {
      await _paymentService.checkPaymentStatus(paymentUlid: paymentUlid);
      emit(VerifyTransactionState.loaded());
    } on Failure catch (e) {
      emit(VerifyTransactionState.error(e.message));
    } catch (e) {
      emit(VerifyTransactionState.error(e.toString()));
    }
  }
}
