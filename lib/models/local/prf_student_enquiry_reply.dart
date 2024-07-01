import 'package:isar/isar.dart';

part 'prf_student_enquiry_reply.g.dart';


@collection
class PRFLocalStudentEnquiryReply {
  PRFLocalStudentEnquiryReply({
    required this.ulid,
    required this.studentEnquiryUlid,
    required this.content,
    required this.createdAt,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  final String studentEnquiryUlid;
  final String content;
  final DateTime createdAt;
}
