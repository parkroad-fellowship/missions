import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/payment_type_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_payment_types_state.dart';
part 'get_payment_types_cubit.freezed.dart';

class GetPaymentTypesCubit extends Cubit<GetPaymentTypesState> {
  GetPaymentTypesCubit({
    required HiveService hiveService,
    required PaymentTypeService paymentTypeService,
  }) : super(const GetPaymentTypesState.initial()) {
    _hiveService = hiveService;
    _paymentTypeService = paymentTypeService;
  }

  late HiveService _hiveService;
  late PaymentTypeService _paymentTypeService;

  Future<void> getPaymentTypes() async {
    try {
      emit(const GetPaymentTypesState.loading());
      final localPaymentTypes = _hiveService.data.retrievePaymentTypes();
      if (localPaymentTypes.isNotEmpty) {
        emit(GetPaymentTypesState.loaded(paymentTypes: localPaymentTypes));
        return;
      }

      final paymentTypes = await _paymentTypeService.list();
      _hiveService.data.payments.persistPaymentTypes(PRFPaymentTypeResponse(paymentTypes));
      emit(GetPaymentTypesState.loaded(paymentTypes: paymentTypes));
    } on Failure catch (e) {
      emit(GetPaymentTypesState.error(e.message));
    } catch (e) {
      emit(GetPaymentTypesState.error(e.toString()));
    }
  }
}
