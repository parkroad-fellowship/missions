import 'package:app/models/local/prf_course.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/utils/_index.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

abstract class LocalDBService {
  Future<Isar> initDatabase();
  Future<void> clearAllTables();

  Future<void> persistCourses({
    required List<PRFCourse> courses,
  });
  Stream<List<PRFLocalCourse>> getCourses();
}

class LocalDBServiceImpl implements LocalDBService {
  @override
  Future<Isar> initDatabase() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return Isar.open(
      [PRFLocalCourseSchema],
      directory: dir.path,
    );
  }

  @override
  Future<void> clearAllTables() async {
    await prfDBInstance.pRFLocalCourses.buildQuery<dynamic>().deleteAll();
  }

  @override
  Future<void> persistCourses({
    required List<PRFCourse> courses,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final course in courses) {
        await prfDBInstance.pRFLocalCourses.put(
          PRFLocalCourse(
            ulid: course.ulid,
            name: course.name,
            slug: course.slug,
            description: course.description,
            isActive: course.isActive,
            createdAt: course.createdAt,
            updatedAt: course.updatedAt,
            thumbnail: course.thumbnail != null
                ? PRFLocalMedia(
                    collectionName: course.thumbnail!.collectionName,
                    fileName: course.thumbnail!.fileName,
                    publicURL: course.thumbnail!.publicURL,
                    publicFullURL: course.thumbnail!.publicFullURL,
                    size: course.thumbnail!.size,
                    humanReadableSize: course.thumbnail!.humanReadableSize,
                    mimeType: course.thumbnail!.mimeType,
                    name: course.thumbnail!.name,
                    createdAt: course.thumbnail!.createdAt,
                    updatedAt: course.thumbnail!.updatedAt,
                  )
                : null,
            courseMember: course.courseMember != null
                ? PRFLocalCourseMember(
                    ulid: course.courseMember!.ulid,
                    percentComplete: course.courseMember!.percentComplete,
                    completionStatus: course.courseMember!.completionStatus,
                    createdAt: course.courseMember!.createdAt,
                    updatedAt: course.courseMember!.updatedAt,
                    completedAt: course.courseMember!.completedAt,
                  )
                : null,
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalCourse>> getCourses() async* {
    await for (final localCourse in prfDBInstance.pRFLocalCourses
        .filter()
        .idGreaterThan(0)
        .build()
        .watch(fireImmediately: true)) {
      yield localCourse;
    }
  }
}
