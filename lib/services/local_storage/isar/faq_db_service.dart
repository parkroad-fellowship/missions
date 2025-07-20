import 'package:app/models/local/prf_faq.dart';
import 'package:app/models/remote/prf_faq.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class FaqDbService extends BaseLocalDBService<PRFFaq, PRFLocalFaq> {
  FaqDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalFaq> get collection => dbInstance.pRFLocalFaqs;

  @override
  PRFLocalFaq remoteToLocal(PRFFaq remote) {
    return PRFLocalFaq(
      ulid: remote.ulid,
      question: remote.question,
      answer: remote.answer,
      categoryUlid: remote.category!.ulid,
    );
  }

  @override
  Stream<List<PRFLocalFaq>> getByParentKey(String categoryUlid) {
    return collection
        .where()
        .categoryUlidEqualTo(categoryUlid)
        .watch(fireImmediately: true);
  }
}
