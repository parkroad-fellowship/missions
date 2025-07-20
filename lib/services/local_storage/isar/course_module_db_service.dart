import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

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

  @override
  Stream<List<PRFLocalCourseModule>> getByParentKey(String courseUlid) {
    return collection
        .where()
        .courseUlidEqualTo(courseUlid)
        .sortByOrder()
        .watch(fireImmediately: true);
  }
}
