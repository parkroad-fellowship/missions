import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:app/services/api/payment_type_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PaymentTypeResourceCubit extends ResourceCubit<PRFPaymentType> {
  PaymentTypeResourceCubit({
    required PaymentTypeService paymentTypeService,
    required HiveService hiveService,
  }) : super(service: paymentTypeService, dbService: hiveService.paymentTypes);
}
