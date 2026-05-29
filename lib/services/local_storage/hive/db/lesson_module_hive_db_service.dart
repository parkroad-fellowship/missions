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

  StreamController<List<PRFLessonModule>>? _parentStreamController;

  Stream<List<PRFLessonModule>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLessonModule>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<List<PRFLessonModule>> listByModule(String moduleUlid) =>
      filterBy((m) => m.module?.ulid == moduleUlid);

  Future<void> refreshParentStream(String moduleUlid) async {
    _parentStreamController ??=
        StreamController<List<PRFLessonModule>>.broadcast();
    _parentStreamController!.add(await listByModule(moduleUlid));
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
