import 'package:app/models/local/faq/prf_faq_category.dart';
import 'package:app/models/remote/content/prf_faq_category.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class FaqCategoryDbService
    extends BaseLocalDBService<PRFFaqCategory, PRFLocalFaqCategory> {
  FaqCategoryDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalFaqCategory> get collection =>
      dbInstance.pRFLocalFaqCategorys;

  @override
  PRFLocalFaqCategory remoteToLocal(PRFFaqCategory remote) {
    return PRFLocalFaqCategory(
      ulid: remote.ulid,
      name: remote.name,
    );
  }
}
