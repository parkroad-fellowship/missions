import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_payments_state.dart';
part 'get_payments_cubit.freezed.dart';

class GetPaymentsCubit extends Cubit<GetPaymentsState> {
  GetPaymentsCubit({
    required HiveService hiveService,
    required PaymentService paymentService,
  }) : super(const GetPaymentsState.initial()) {
    _hiveService = hiveService;
    _paymentService = paymentService;
  }

  late HiveService _hiveService;
  late PaymentService _paymentService;

  Future<void> getPayments() async {
    try {
      emit(const GetPaymentsState.loading());
      final member = _hiveService.retrieveMember()!;

      final payments = await _paymentService.list(
        filters: {
          'member_ulid': member.ulid,
        },
        includes: ['paymentType'],
      );

      if (payments.isEmpty) {
        emit(const GetPaymentsState.empty());
        return;
      }

      emit(GetPaymentsState.loaded(payments: payments));
    } on Failure catch (e) {
      emit(GetPaymentsState.error(e.message));
    } catch (e) {
      emit(GetPaymentsState.error(e.toString()));
    }
  }
}
