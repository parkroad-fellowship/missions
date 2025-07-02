import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_payment.dart';
import 'package:app/models/remote/prf_payment_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_payment_cubit.freezed.dart';
part 'add_payment_state.dart';

class AddPaymentCubit extends Cubit<AddPaymentState> {
  AddPaymentCubit({
    required HiveService hiveService,
    required PaymentService paymentService,
  }) : super(const AddPaymentState.initial()) {
    _hiveService = hiveService;
    _paymentService = paymentService;
  }

  late HiveService _hiveService;
  late PaymentService _paymentService;

  Future<void> addPayment({
    required String amount,
    required String paymentTypeUlid,
  }) async {
    try {
      emit(const AddPaymentState.loading());
      final member = _hiveService.retrieveMember()!;

      final payment = await _paymentService.create(
        data: PRFPaymentDTO(
          memberUlid: member.ulid,
          paymentTypeUlid: paymentTypeUlid,
          amount: int.parse(amount),
        ).toJson(),
      );

      emit(AddPaymentState.loaded(payment: payment));
    } on Failure catch (e) {
      emit(AddPaymentState.error(e.message));
    } catch (e) {
      emit(AddPaymentState.error(e.toString()));
    }
  }
}
