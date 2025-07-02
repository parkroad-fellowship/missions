import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/services/_base_api_service.dart';

class PaymentTypeService extends BaseAPIService<PRFPaymentType> {
  @override
  String get endpoint => '/payment-types';

  @override
  PRFPaymentType createFromJson(Map<String, dynamic> json) {
    return PRFPaymentType.fromJson(json);
  }

  @override
  List<PRFPaymentType> createListFromResponse(Map<String, dynamic> response) {
    return PRFPaymentTypeResponse.fromJson(response).data;
  }
}
