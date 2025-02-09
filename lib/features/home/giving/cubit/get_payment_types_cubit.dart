import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_payment_types_state.dart';
part 'get_payment_types_cubit.freezed.dart';

class GetPaymentTypesCubit extends Cubit<GetPaymentTypesState> {
  GetPaymentTypesCubit({
    required HiveService hiveService,
    required PaymentService paymentService,
  }) : super(const GetPaymentTypesState.initial()) {
    _hiveService = hiveService;
    _paymentService = paymentService;
  }

  late HiveService _hiveService;
  late PaymentService _paymentService;

  Future<void> getPaymentTypes() async {
    try {
      emit(const GetPaymentTypesState.loading());
      final localPaymentTypes = _hiveService.retrievePaymentTypes();
      if (localPaymentTypes.isNotEmpty) {
        emit(GetPaymentTypesState.loaded(paymentTypes: localPaymentTypes));
        return;
      }

      final paymentTypes = await _paymentService.getPaymentTypes();
      _hiveService.persistPaymentTypes(PRFPaymentTypeResponse(paymentTypes));
      emit(GetPaymentTypesState.loaded(paymentTypes: paymentTypes));
    } on Failure catch (e) {
      emit(GetPaymentTypesState.error(e.message));
    } catch (e) {
      emit(GetPaymentTypesState.error(e.toString()));
    }
  }
}
