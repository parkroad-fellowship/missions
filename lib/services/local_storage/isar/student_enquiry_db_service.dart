import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class StudentEnquiryDbService
    extends BaseLocalDBService<PRFStudentEnquiry, PRFLocalStudentEnquiry> {
  StudentEnquiryDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalStudentEnquiry> get collection =>
      dbInstance.pRFLocalStudentEnquirys;

  @override
  PRFLocalStudentEnquiry remoteToLocal(PRFStudentEnquiry remote) {
    return PRFLocalStudentEnquiry(
      ulid: remote.ulid,
      hasReplies: remote.hasReplies,
      content: remote.content,
      createdAt: remote.createdAt,
    );
  }
}
