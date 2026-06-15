import 'dart:async';

import 'package:app/models/remote/course/prf_lesson_module.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class LessonModuleHiveDbService extends BaseHiveDbService<PRFLessonModule> {
  @override
  String get boxName => 'prf_lesson_modules';

  @override
  String getKey(PRFLessonModule entity) => entity.ulid;

  @override
  PRFLessonModule fromJson(Map<String, dynamic> json) =>
      PRFLessonModule.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFLessonModule entity) => entity.toJson();

  // ----- Parent (module) stream -----

  Future<List<PRFLessonModule>> listByModule(String moduleUlid) =>
      filterBy((m) => [m.module?.ulid == moduleUlid]);

  Stream<List<PRFLessonModule>> watchByParent(String parentId) =>
      stream.asyncMap((_) => listByModule(parentId));
}
