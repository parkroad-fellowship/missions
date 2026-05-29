import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class FaqCategoryHiveDbService extends BaseHiveDbService<PRFFaqCategory> {
  @override
  String get boxName => 'prf_faq_categories';

  @override
  String getKey(PRFFaqCategory entity) => entity.ulid;

  @override
  PRFFaqCategory fromJson(Map<String, dynamic> json) =>
      PRFFaqCategory.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFFaqCategory entity) => entity.toJson();
}
