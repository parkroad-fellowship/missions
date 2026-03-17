import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/services/api/payment_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PaymentResourceCubit extends ResourceCubit<PRFPayment> {
  PaymentResourceCubit({
    required PaymentService paymentService,
    BaseLocalDBService<PRFPayment, dynamic>? dbService,
  }) : super(service: paymentService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['paymentType'];

  /// Create a payment.
  Future<void> addPayment({required Map<String, dynamic> data}) async {
    await create(data: data);
  }
}
