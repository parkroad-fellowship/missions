import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/models/remote/prf_faq_category.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

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
