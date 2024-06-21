import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/utils/_index.dart';

abstract class LMSService {
  Future<List<PRFCourse>> getCourses({
    String? includes,
  });
  Future<List<PRFCourseModule>> getCourseModules({
    String? courseUlid,
    String? includes,
  });
}

class LMSServiceImpl implements LMSService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFCourse>> getCourses({
    String? includes,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/courses',
        queryParameters: {
          if (includes != null) 'include': includes,
        },
      );

      return PRFCourseResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFCourseModule>> getCourseModules({
    String? courseUlid,
    String? includes,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/course-modules',
        queryParameters: {
          if (courseUlid != null) 'filter[course_ulid]': courseUlid,
          if (includes != null) 'include': includes,
        },
      );

      return PRFCourseModuleResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
