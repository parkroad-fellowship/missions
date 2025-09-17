import 'dart:async';

import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class CourseModuleDbService
    extends BaseLocalDBService<PRFCourseModule, PRFLocalCourseModule> {
  CourseModuleDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalCourseModule> get collection =>
      dbInstance.pRFLocalCourseModules;

  @override
  PRFLocalCourseModule remoteToLocal(PRFCourseModule remote) {
    return PRFLocalCourseModule(
      ulid: remote.ulid,
      courseUlid: remote.course!.ulid,
      moduleUlid: remote.module!.ulid,
      order: remote.order,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      memberModule: remote.memberModule != null
          ? PRFLocalMemberModule(
              ulid: remote.memberModule!.ulid,
              percentComplete: remote.memberModule!.percentComplete,
              completionStatus: remote.memberModule!.completionStatus,
              createdAt: remote.memberModule!.createdAt,
              updatedAt: remote.memberModule!.updatedAt,
              completedAt: remote.memberModule!.completedAt,
            )
          : null,
      module: PRFLocalModule(
        ulid: remote.module!.ulid,
        name: remote.module!.name,
        description: remote.module!.description,
        createdAt: remote.module!.createdAt,
        thumbnail: remote.module!.thumbnail != null
            ? PRFLocalMedia(
                collectionName: remote.module!.thumbnail!.collectionName,
                fileName: remote.module!.thumbnail!.fileName,
                temporaryURL: remote.module!.thumbnail!.temporaryURL,
                size: remote.module!.thumbnail!.size,
                humanReadableSize: remote.module!.thumbnail!.humanReadableSize,
                mimeType: remote.module!.thumbnail!.mimeType,
                name: remote.module!.thumbnail!.name,
                createdAt: remote.module!.thumbnail!.createdAt,
                updatedAt: remote.module!.thumbnail!.updatedAt,
              )
            : null,
      ),
    );
  }

  Future<List<PRFLocalCourseModule>> listParentModules(
    String parentKey,
  ) async {
    return collection.where().courseUlidEqualTo(parentKey).findAll();
  }

  StreamController<List<PRFLocalCourseModule>>? _parentStreamController;
  Stream<List<PRFLocalCourseModule>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalCourseModule>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalCourseModule>>.broadcast();
    final entities = await listParentModules(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }

  @override
  Future<PRFLocalCourseModule?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }
}
