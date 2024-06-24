import 'dart:convert';

import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/models/remote/prf_lesson_member_dto.dart';
import 'package:app/utils/_index.dart';

abstract class LMSService {
  Future<List<PRFCourse>> getCourses({
    List<String> groups = const <String>[],
    String? includes,
  });
  Future<List<PRFCourseModule>> getCourseModules({
    String? courseUlid,
    String? includes,
  });
  Future<void> finishLesson({
    required PRFLessonMemberDTO lessonMemberDTO,
  });
}

class LMSServiceImpl implements LMSService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFCourse>> getCourses({
    List<String> groups = const <String>[],
    String? includes,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/courses',
        queryParameters: {
          if (includes != null) 'include': includes,
          'filter[group_ulids]': groups.join(','),
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

  @override
  Future<void> finishLesson({
    required PRFLessonMemberDTO lessonMemberDTO,
  }) async {
    try {
      await _networkUtil.postReq(
        '/lesson-members',
        body: json.encode(lessonMemberDTO.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }
}
