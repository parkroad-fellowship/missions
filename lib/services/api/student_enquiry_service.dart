import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:app/services/api/_base_api_service.dart';

class StudentEnquiryService extends BaseAPIService<PRFStudentEnquiry> {
  @override
  String get endpoint => '/student-enquiries';

  @override
  PRFStudentEnquiry createFromJson(Map<String, dynamic> json) {
    return PRFStudentEnquiry.fromJson(json);
  }

  @override
  List<PRFStudentEnquiry> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFStudentEnquiryResponse.fromJson(response).data;
  }
}
