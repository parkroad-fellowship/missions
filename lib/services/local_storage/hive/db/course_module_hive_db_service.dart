import 'dart:async';

import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class CourseModuleHiveDbService extends BaseHiveDbService<PRFCourseModule> {
  @override
  String get boxName => 'prf_course_modules';

  @override
  String getKey(PRFCourseModule entity) => entity.ulid;

  @override
  PRFCourseModule fromJson(Map<String, dynamic> json) =>
      PRFCourseModule.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFCourseModule entity) => entity.toJson();

  // ----- Parent (course) stream -----

  Future<List<PRFCourseModule>> listByCourse(String courseUlid) =>
      filterBy((m) => m.course?.ulid == courseUlid);

  Stream<List<PRFCourseModule>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByCourse(parentId));
}
