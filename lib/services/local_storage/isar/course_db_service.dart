import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

class CourseDbService extends BaseLocalDBService<PRFCourse, PRFLocalCourse> {
  CourseDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalCourse> get collection => dbInstance.pRFLocalCourses;

  @override
  PRFLocalCourse remoteToLocal(PRFCourse remote) {
    return PRFLocalCourse(
      ulid: remote.ulid,
      name: remote.name,
      description: remote.description,
      createdAt: remote.createdAt,
      thumbnail: remote.thumbnail != null
          ? PRFLocalMedia(
              collectionName: remote.thumbnail!.collectionName,
              fileName: remote.thumbnail!.fileName,
              temporaryURL: remote.thumbnail!.temporaryURL,
              size: remote.thumbnail!.size,
              humanReadableSize: remote.thumbnail!.humanReadableSize,
              mimeType: remote.thumbnail!.mimeType,
              name: remote.thumbnail!.name,
              createdAt: remote.thumbnail!.createdAt,
              updatedAt: remote.thumbnail!.updatedAt,
            )
          : null,
      courseMember: remote.courseMember != null
          ? PRFLocalCourseMember(
              ulid: remote.courseMember!.ulid,
              percentComplete: remote.courseMember!.percentComplete,
              completionStatus: remote.courseMember!.completionStatus,
              createdAt: remote.courseMember!.createdAt,
              updatedAt: remote.courseMember!.updatedAt,
              completedAt: remote.courseMember!.completedAt,
            )
          : null,
    );
  }

  @override
  Future<PRFLocalCourse?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }
}
