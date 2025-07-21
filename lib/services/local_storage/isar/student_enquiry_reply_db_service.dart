import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/prf_student_enquiry_reply.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class StudentEnquiryReplyDbService
    extends
        BaseLocalDBService<
          PRFStudentEnquiryReply,
          PRFLocalStudentEnquiryReply
        > {
  StudentEnquiryReplyDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalStudentEnquiryReply> get collection =>
      dbInstance.pRFLocalStudentEnquiryReplys;

  @override
  PRFLocalStudentEnquiryReply remoteToLocal(PRFStudentEnquiryReply remote) {
    return PRFLocalStudentEnquiryReply(
      ulid: remote.ulid,
      studentEnquiryUlid: remote.studentEnquiry!.ulid,
      content: remote.content,
      createdAt: remote.createdAt,
      commentorableType: remote.commentorableType,
      isStudent: remote.commentorableType == PRFMorphType.student,
    );
  }

  @override
  Stream<List<PRFLocalStudentEnquiryReply>> getByParentKey(
    String parentKey,
  ) {
    return collection
        .where()
        .studentEnquiryUlidEqualTo(parentKey)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
