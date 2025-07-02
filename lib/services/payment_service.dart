import 'package:app/models/remote/prf_payment.dart';
import 'package:app/services/_base_api_service.dart';

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
