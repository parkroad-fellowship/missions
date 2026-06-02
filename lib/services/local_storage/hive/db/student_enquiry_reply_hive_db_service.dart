import 'dart:async';

import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class StudentEnquiryReplyHiveDbService
    extends BaseHiveDbService<PRFStudentEnquiryReply> {
  @override
  String get boxName => 'prf_student_enquiry_replies';

  @override
  String getKey(PRFStudentEnquiryReply entity) => entity.ulid;

  @override
  PRFStudentEnquiryReply fromJson(Map<String, dynamic> json) =>
      PRFStudentEnquiryReply.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFStudentEnquiryReply entity) => entity.toJson();

  // ----- Parent (student enquiry) stream -----

  Future<List<PRFStudentEnquiryReply>> listByEnquiry(String enquiryUlid) =>
      filterBy((r) => [r.studentEnquiry?.ulid == enquiryUlid]);

  Stream<List<PRFStudentEnquiryReply>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByEnquiry(parentId));
}
