import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/services/api/_base_api_service.dart';

class PaymentService extends BaseAPIService<PRFPayment> {
  @override
  String get endpoint => '/payments';

  @override
  PRFPayment createFromJson(Map<String, dynamic> json) {
    return PRFPayment.fromJson(json);
  }

  @override
  List<PRFPayment> createListFromResponse(Map<String, dynamic> response) {
    return PRFPaymentResponse.fromJson(response).data;
  }
}
