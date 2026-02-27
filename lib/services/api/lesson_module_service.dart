import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/services/api/_base_api_service.dart';

class LessonModuleService extends BaseAPIService<PRFLessonModule> {
  @override
  String get endpoint => '/lesson-modules';

  @override
  PRFLessonModule createFromJson(Map<String, dynamic> json) {
    return PRFLessonModule.fromJson(json);
  }

  @override
  List<PRFLessonModule> createListFromResponse(Map<String, dynamic> response) {
    return PRFLessonModuleResponse.fromJson(response).data;
  }
}
