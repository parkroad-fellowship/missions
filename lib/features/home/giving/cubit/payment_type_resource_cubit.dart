import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:app/services/api/payment_type_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PaymentTypeResourceCubit extends ResourceCubit<PRFPaymentType> {
  PaymentTypeResourceCubit({
    required PaymentTypeService paymentTypeService,
    BaseLocalDBService<PRFPaymentType, dynamic>? dbService,
  }) : super(service: paymentTypeService, dbService: dbService);
}
