import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class CourseHiveDbService extends BaseHiveDbService<PRFCourse> {
  @override
  String get boxName => 'prf_courses';

  @override
  String getKey(PRFCourse entity) => entity.ulid;

  @override
  PRFCourse fromJson(Map<String, dynamic> json) => PRFCourse.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFCourse entity) => entity.toJson();
}
