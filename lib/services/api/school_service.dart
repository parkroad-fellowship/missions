import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/services/api/_base_api_service.dart';

class SchoolService extends BaseAPIService<PRFSchool> {
  @override
  String get endpoint => '/schools';

  @override
  PRFSchool createFromJson(Map<String, dynamic> json) {
    return PRFSchool.fromJson(json);
  }

  @override
  List<PRFSchool> createListFromResponse(Map<String, dynamic> response) {
    return PRFSchoolsResponse.fromJson(response).data;
  }
}
