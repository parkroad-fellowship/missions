import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/api/_base_api_service.dart';

class StudentEnquiryReplyService
    extends BaseAPIService<PRFStudentEnquiryReply> {
  @override
  String get endpoint => '/student-enquiry-replies';

  @override
  PRFStudentEnquiryReply createFromJson(Map<String, dynamic> json) {
    return PRFStudentEnquiryReply.fromJson(json);
  }

  @override
  List<PRFStudentEnquiryReply> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFStudentEnquiryReplyResponse.fromJson(response).data;
  }
}
