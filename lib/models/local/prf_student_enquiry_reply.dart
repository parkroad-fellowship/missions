import 'package:isar/isar.dart';

part 'prf_student_enquiry_reply.g.dart';

@collection
class PRFLocalStudentEnquiryReply {
  PRFLocalStudentEnquiryReply({
    required this.ulid,
    required this.studentEnquiryUlid,
    required this.content,
    required this.createdAt,
    required this.commentorableType,
    required this.isStudent,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  final String studentEnquiryUlid;
  final String content;
  final DateTime createdAt;
  final int commentorableType;
  final bool isStudent;
}
