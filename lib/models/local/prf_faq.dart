import 'package:isar/isar.dart';

part 'prf_faq.g.dart';

@collection
class PRFLocalFaq {
  PRFLocalFaq({
    required this.ulid,
    required this.categoryUlid,
    required this.question,
    required this.answer,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String categoryUlid;

  final String question;
  @Index()
  List<String> get questionWords => Isar.splitWords(question);

  final String answer;

  @Index()
  List<String> get answerWords => Isar.splitWords(answer);
}
