import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/services/api/_base_api_service.dart';

class CourseModuleService extends BaseAPIService<PRFCourseModule> {
  @override
  String get endpoint => '/course-modules';

  @override
  PRFCourseModule createFromJson(Map<String, dynamic> json) {
    return PRFCourseModule.fromJson(json);
  }

  @override
  List<PRFCourseModule> createListFromResponse(Map<String, dynamic> response) {
    return PRFCourseModuleResponse.fromJson(response).data;
  }
}
