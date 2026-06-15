import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class StudentEnquiryHiveDbService extends BaseHiveDbService<PRFStudentEnquiry> {
  @override
  String get boxName => 'prf_student_enquiries';

  @override
  String getKey(PRFStudentEnquiry entity) => entity.ulid;

  @override
  PRFStudentEnquiry fromJson(Map<String, dynamic> json) =>
      PRFStudentEnquiry.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFStudentEnquiry entity) => entity.toJson();
}
