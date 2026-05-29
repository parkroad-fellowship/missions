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

  StreamController<List<PRFCourseModule>>? _parentStreamController;

  Stream<List<PRFCourseModule>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFCourseModule>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<List<PRFCourseModule>> listByCourse(String courseUlid) =>
      filterBy((m) => m.course?.ulid == courseUlid);

  Future<void> refreshParentStream(String courseUlid) async {
    _parentStreamController ??=
        StreamController<List<PRFCourseModule>>.broadcast();
    _parentStreamController!.add(await listByCourse(courseUlid));
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
