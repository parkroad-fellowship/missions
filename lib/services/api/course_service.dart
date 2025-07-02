import 'package:app/models/remote/prf_course.dart';
import 'package:app/services/api/_base_api_service.dart';

class CourseService extends BaseAPIService<PRFCourse> {
  @override
  String get endpoint => '/courses';

  @override
  PRFCourse createFromJson(Map<String, dynamic> json) {
    return PRFCourse.fromJson(json);
  }

  @override
  List<PRFCourse> createListFromResponse(Map<String, dynamic> response) {
    return PRFCourseResponse.fromJson(response).data;
  }
}
