import 'package:isar/isar.dart';

part 'prf_faq_category.g.dart';

@collection
class PRFLocalFaqCategory {
  PRFLocalFaqCategory({
    required this.ulid,
    required this.name,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String name;
}
