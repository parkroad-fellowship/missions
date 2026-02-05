import 'package:app/models/local/faq/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

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
  Future<List<PRFLocalFaq>> list({
    String? categoryUlid,
    String? query,
  }) async {
    return collection
        .where()
        .filter()
        .optional(
          categoryUlid != null,
          (q) => q.categoryUlidEqualTo(categoryUlid!),
        )
        .optional(
          query != null,
          (q) => q
              .questionWordsElementContains(query!)
              .answerWordsElementContains(query),
        )
        .findAll();
  }

  Stream<List<PRFLocalFaq>> filter({String? categoryUlid, String? query}) {
    return collection
        .where()
        .filter()
        .optional(
          categoryUlid != null,
          (q) => q.categoryUlidEqualTo(categoryUlid!),
        )
        .optional(
          query != null,
          (q) => q
              .questionWordsElementContains(query!)
              .answerWordsElementContains(query),
        )
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
