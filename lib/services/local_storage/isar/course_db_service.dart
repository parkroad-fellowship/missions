import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/models/local/course/prf_course.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course_member.dart';
import 'package:app/models/remote/media/prf_media.dart';
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
  PRFCourse localToRemote(PRFLocalCourse local) {
    return PRFCourse(
      local.ulid,
      local.name,
      '',
      local.description,
      1,
      local.createdAt,
      local.createdAt,
      thumbnail: local.thumbnail == null
          ? null
          : PRFMedia(
              local.thumbnail!.fileName ?? local.ulid,
              local.thumbnail!.temporaryURL ?? '',
              local.thumbnail!.size ?? 0,
              local.thumbnail!.humanReadableSize ?? '',
              local.thumbnail!.mimeType ?? '',
              local.thumbnail!.name ?? '',
              local.thumbnail!.fileName ?? '',
              local.thumbnail!.collectionName ?? '',
              local.thumbnail!.createdAt ?? local.createdAt,
              local.thumbnail!.updatedAt ?? local.createdAt,
            ),
      courseMember: local.courseMember == null
          ? null
          : PRFCourseMember(
              local.courseMember!.ulid ?? local.ulid,
              local.courseMember!.percentComplete ?? 0,
              local.courseMember!.completionStatus ??
                  PRFCompletionStatus.incomplete,
              local.courseMember!.createdAt ?? local.createdAt,
              local.courseMember!.updatedAt ?? local.createdAt,
              completedAt: local.courseMember!.completedAt,
            ),
    );
  }

  @override
  Future<PRFLocalCourse?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }
}
