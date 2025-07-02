import 'package:app/models/remote/prf_lesson_member.dart';
import 'package:app/services/_base_api_service.dart';

class LessonMemberService extends BaseAPIService<PRFLessonMember> {
  @override
  String get endpoint => '/lesson-members';

  @override
  PRFLessonMember createFromJson(Map<String, dynamic> json) {
    return PRFLessonMember.fromJson(json);
  }

  @override
  List<PRFLessonMember> createListFromResponse(Map<String, dynamic> response) {
    throw UnimplementedError(
        'createListFromResponse is not implemented for LessonMemberService');
  }
}
