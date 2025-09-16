import 'package:isar_community/isar.dart';

part 'prf_student_enquiry.g.dart';

@collection
class PRFLocalStudentEnquiry {
  PRFLocalStudentEnquiry({
    required this.ulid,
    required this.content,
    required this.hasReplies,
    required this.createdAt,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  final String content;
  final bool hasReplies;
  final DateTime createdAt;
}
