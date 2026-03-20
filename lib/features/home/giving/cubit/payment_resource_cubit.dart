import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/models/remote/payment/prf_payment_dto.dart';
import 'package:app/services/api/payment_service.dart';
import 'package:app/services/local_storage/_index.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class PaymentResourceCubit extends ResourceCubit<PRFPayment> {
  PaymentResourceCubit({
    required PaymentService paymentService,
    required HiveService hiveService,
    super.dbService,
  }) : _hiveService = hiveService,
       super(service: paymentService);

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => ['paymentType'];

  /// Create a payment.
  Future<void> addPayment({
    required String paymentTypeUlid,
    required int amount,
  }) async {
    final dto = PRFPaymentDTO(
      paymentTypeUlid: paymentTypeUlid,
      memberUlid: _hiveService.retrieveMember()!.ulid,
      amount: amount,
    );
    await create(data: dto.toJson());
  }
}
