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
  Stream<PRFLocalCourse> getCourse({
    required String courseUlid,
  });

  Future<void> persistCourseModules({
    required List<PRFCourseModule> courseModules,
    required String courseUlid,
  });
  Future<void> updateCourseModuleProgress({
    required String courseModuleUlid,
    required double percentComplete,
  });
  Future<void> updateLessonMemberProgress({
    required String courseUlid,
    required String moduleUlid,
    required String lessonMemberUlid,
    required int completionStatus,
  });
  Stream<List<PRFLocalCourseModule>> getCourseModules({
    required String courseUlid,
  });
  Stream<PRFLocalCourseModule> getCourseModule({
    required String courseModuleUlid,
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
    await prfDBInstance.writeTxn(() async {
      await prfDBInstance.clear();
    });
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
  Stream<PRFLocalCourse> getCourse({
    required String courseUlid,
  }) async* {
    await for (final localCourse in prfDBInstance.pRFLocalCourses
        .filter()
        .ulidEqualTo(courseUlid)
        .build()
        .watch(fireImmediately: true)) {
      yield localCourse.first;
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
              ulid: courseModule.module!.ulid,
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
              lessonModules: courseModule.module!.lessonModules
                  ?.map(
                    (lessonModule) => PRFLocalLessonModule(
                      ulid: lessonModule.ulid,
                      order: lessonModule.order,
                      createdAt: lessonModule.createdAt,
                      updatedAt: lessonModule.updatedAt,
                      lesson: PRFLocalLesson(
                        ulid: lessonModule.lesson!.ulid,
                        name: lessonModule.lesson!.name,
                        slug: lessonModule.lesson!.slug,
                        description: lessonModule.lesson!.description,
                        type: lessonModule.lesson!.type,
                        isActive: lessonModule.lesson!.isActive,
                        createdAt: lessonModule.lesson!.createdAt,
                        updatedAt: lessonModule.lesson!.updatedAt,
                        content: lessonModule.lesson!.content,
                        videoUrl: lessonModule.lesson!.videoUrl,
                        audioUrl: lessonModule.lesson!.audioUrl,
                        documentUrl: lessonModule.lesson!.documentUrl,
                        deletedAt: lessonModule.lesson!.deletedAt,
                        audios: lessonModule.lesson!.audios
                            ?.map(
                              (audio) => PRFLocalMedia(
                                collectionName: audio.collectionName,
                                fileName: audio.fileName,
                                publicURL: audio.publicURL,
                                publicFullURL: audio.publicFullURL,
                                size: audio.size,
                                humanReadableSize: audio.humanReadableSize,
                                mimeType: audio.mimeType,
                                name: audio.name,
                                createdAt: audio.createdAt,
                                updatedAt: audio.updatedAt,
                              ),
                            )
                            .toList(),
                        documents: lessonModule.lesson!.documents
                            ?.map(
                              (document) => PRFLocalMedia(
                                collectionName: document.collectionName,
                                fileName: document.fileName,
                                publicURL: document.publicURL,
                                publicFullURL: document.publicFullURL,
                                size: document.size,
                                humanReadableSize: document.humanReadableSize,
                                mimeType: document.mimeType,
                                name: document.name,
                                createdAt: document.createdAt,
                                updatedAt: document.updatedAt,
                              ),
                            )
                            .toList(),
                        videos: lessonModule.lesson!.videos
                            ?.map(
                              (video) => PRFLocalMedia(
                                collectionName: video.collectionName,
                                fileName: video.fileName,
                                publicURL: video.publicURL,
                                publicFullURL: video.publicFullURL,
                                size: video.size,
                                humanReadableSize: video.humanReadableSize,
                                mimeType: video.mimeType,
                                name: video.name,
                                createdAt: video.createdAt,
                                updatedAt: video.updatedAt,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> updateCourseModuleProgress({
    required String courseModuleUlid,
    required double percentComplete,
  }) async {
    await prfDBInstance.writeTxn(() async {
      final courseModule = await prfDBInstance.pRFLocalCourseModules
          .filter()
          .ulidEqualTo(courseModuleUlid)
          .build()
          .findFirst();
      courseModule!.module.memberModule!.percentComplete = percentComplete;
      await prfDBInstance.pRFLocalCourseModules.put(courseModule);
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

  @override
  Stream<PRFLocalCourseModule> getCourseModule({
    required String courseModuleUlid,
  }) async* {
    await for (final localCourseModule in prfDBInstance.pRFLocalCourseModules
        .filter()
        .ulidEqualTo(courseModuleUlid)
        .build()
        .watch(fireImmediately: true)) {
      yield localCourseModule.first;
    }
  }

  @override
  Future<void> updateLessonMemberProgress({
    required String courseUlid,
    required String moduleUlid,
    required String lessonMemberUlid,
    required int completionStatus,
  }) async {
    await prfDBInstance.writeTxn(() async {
      final courseModule = await prfDBInstance.pRFLocalCourseModules
          .filter()
          .courseUlidEqualTo(courseUlid)
          .module((q) => q.ulidEqualTo(moduleUlid))
          .build()
          .findFirst();

      final lessonModule = courseModule!.module.lessonModules!.firstWhere(
        (element) => element.lessonMember?.ulid == lessonMemberUlid,
      );

      lessonModule.lessonMember?.completionStatus = completionStatus;

      courseModule.module.lessonModules = courseModule.module.lessonModules!
          .map(
            (element) =>
                element.ulid == lessonModule.ulid ? lessonModule : element,
          )
          .toList();

      await prfDBInstance.pRFLocalCourseModules.put(courseModule);
    });
  }
}
