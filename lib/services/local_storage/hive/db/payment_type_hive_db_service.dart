import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class PaymentTypeHiveDbService extends BaseHiveDbService<PRFPaymentType> {
  @override
  String get boxName => 'prf_payment_types';

  @override
  String getKey(PRFPaymentType entity) => entity.ulid;

  @override
  PRFPaymentType fromJson(Map<String, dynamic> json) =>
      PRFPaymentType.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFPaymentType entity) => entity.toJson();
}
