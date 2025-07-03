import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class PaymentTypeHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  void persistPaymentTypes(PRFPaymentTypeResponse paymentTypes) {
    put('paymentTypes', paymentTypes);
  }

  List<PRFPaymentType> retrievePaymentTypes() {
    final paymentTypes = get<PRFPaymentTypeResponse>('paymentTypes');
    if (paymentTypes == null) return [];
    return paymentTypes.data;
  }

  void clearPaymentTypes() {
    delete('paymentTypes');
  }
}
