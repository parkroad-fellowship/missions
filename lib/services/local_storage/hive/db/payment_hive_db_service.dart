import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class PaymentHiveDbService extends BaseHiveDbService<PRFPayment> {
  @override
  String get boxName => 'prf_payments';

  @override
  String getKey(PRFPayment entity) => entity.ulid;

  @override
  PRFPayment fromJson(Map<String, dynamic> json) => PRFPayment.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFPayment entity) => entity.toJson();
}
