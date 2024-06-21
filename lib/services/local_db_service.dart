import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_course_module.dart';
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

  Future<void> persistCourseModules({
    required List<PRFCourseModule> courseModules,
    required String courseUlid,
  });
  Stream<List<PRFLocalCourseModule>> getCourseModules({
    required String courseUlid,
  });
}

class LocalDBServiceImpl implements LocalDBService {
  @override
  Future<Isar> initDatabase() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return Isar.open(
      [
        PRFLocalCourseSchema,
        PRFLocalCourseModuleSchema,
      ],
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

  @override
  Future<void> persistCourseModules({
    required List<PRFCourseModule> courseModules,
    required String courseUlid,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final courseModule in courseModules) {
        await prfDBInstance.pRFLocalCourseModules.put(
          PRFLocalCourseModule(
            ulid: courseModule.ulid,
            courseUlid: courseUlid,
            order: courseModule.order,
            createdAt: courseModule.createdAt,
            updatedAt: courseModule.updatedAt,
            module: PRFLocalModule(
              ulid: courseModule.ulid,
              name: courseModule.module!.name,
              slug: courseModule.module!.slug,
              description: courseModule.module!.description,
              isActive: courseModule.module!.isActive,
              createdAt: courseModule.module!.createdAt,
              updatedAt: courseModule.module!.updatedAt,
              thumbnail: courseModule.module!.thumbnail != null
                  ? PRFLocalMedia(
                      collectionName:
                          courseModule.module!.thumbnail!.collectionName,
                      fileName: courseModule.module!.thumbnail!.fileName,
                      publicURL: courseModule.module!.thumbnail!.publicURL,
                      publicFullURL:
                          courseModule.module!.thumbnail!.publicFullURL,
                      size: courseModule.module!.thumbnail!.size,
                      humanReadableSize:
                          courseModule.module!.thumbnail!.humanReadableSize,
                      mimeType: courseModule.module!.thumbnail!.mimeType,
                      name: courseModule.module!.thumbnail!.name,
                      createdAt: courseModule.module!.thumbnail!.createdAt,
                      updatedAt: courseModule.module!.thumbnail!.updatedAt,
                    )
                  : null,
              memberModule: courseModule.module!.memberModule != null
                  ? PRFLocalMemberModule(
                      ulid: courseModule.module!.memberModule!.ulid,
                      percentComplete:
                          courseModule.module!.memberModule!.percentComplete,
                      completionStatus:
                          courseModule.module!.memberModule!.completionStatus,
                      createdAt: courseModule.module!.memberModule!.createdAt,
                      updatedAt: courseModule.module!.memberModule!.updatedAt,
                      completedAt:
                          courseModule.module!.memberModule!.completedAt,
                    )
                  : null,
            ),
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalCourseModule>> getCourseModules({
    required String courseUlid,
  }) async* {
    await for (final localCourseModule in prfDBInstance.pRFLocalCourseModules
        .filter()
        .courseUlidEqualTo(courseUlid)
        .build()
        .watch(fireImmediately: true)) {
      yield localCourseModule;
    }
  }
}
