import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class FaqHiveDbService extends BaseHiveDbService<PRFFaq> {
  @override
  String get boxName => 'prf_faqs';

  @override
  String getKey(PRFFaq entity) => entity.ulid;

  @override
  PRFFaq fromJson(Map<String, dynamic> json) => PRFFaq.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFFaq entity) => entity.toJson();
}
