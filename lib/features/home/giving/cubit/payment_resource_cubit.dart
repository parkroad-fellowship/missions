import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/services/api/payment_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PaymentResourceCubit extends ResourceCubit<PRFPayment> {
  PaymentResourceCubit({
    required PaymentService paymentService,
    super.dbService,
  }) : super(service: paymentService);

  @override
  List<String> get defaultIncludes => ['paymentType'];

  /// Create a payment.
  Future<void> addPayment({required Map<String, dynamic> data}) async {
    await create(data: data);
  }
}
