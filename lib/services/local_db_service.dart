import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/models/local/prf_prayer_response.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/models/remote/prf_lesson_module.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/models/remote/prf_student_enquiry.dart';
import 'package:app/models/remote/prf_student_enquiry_reply.dart';
import 'package:app/utils/_index.dart';
import 'package:collection/collection.dart' as collection;
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
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
  Stream<List<PRFLocalCourseModule>> getCourseModules({
    required String courseUlid,
  });
  Stream<PRFLocalCourseModule> getCourseModule({
    required String courseModuleUlid,
  });

  Future<void> persistLessonModules({
    required List<PRFLessonModule> lessonModules,
  });
  Stream<List<PRFLocalLessonModule>> getLessonModules({
    required String moduleUlid,
  });
  Future<void> persistStudentEnquiries({
    required List<PRFStudentEnquiry> enquiries,
  });
  Stream<List<PRFLocalStudentEnquiry>> getStudentEnquiries();

  Future<void> persistStudentEnquiryReplies({
    required String studentEnquiryUlid,
    required List<PRFStudentEnquiryReply> replies,
  });
  Stream<List<PRFLocalStudentEnquiryReply>> getStudentEnquiryReplies({
    required String studentEnquiryUlid,
  });
  Future<void> persistAnnouncements({
    required List<PRFAnnouncement> announcements,
  });
  Stream<Map<DateTime, List<PRFLocalAnnouncement>>> getAnnouncements();
  Future<void> persistPrayerResponses({
    required List<PRFPrayerResponseDTO> prayerResponses,
  });
  List<PRFPrayerResponseDTO> retrievePrayerResponses();
  void deletePrayerResponse({
    required String prayerPromptUlid,
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
        PRFLocalLessonModuleSchema,
        PRFLocalStudentEnquirySchema,
        PRFLocalStudentEnquiryReplySchema,
        PRFLocalAnnouncementSchema,
        PRFLocalPrayerResponseSchema,
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
            description: course.description,
            createdAt: course.createdAt,
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
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
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
        .sortByCreatedAt()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
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
            moduleUlid: courseModule.module!.ulid,
            order: courseModule.order,
            createdAt: courseModule.createdAt,
            updatedAt: courseModule.updatedAt,
            memberModule: courseModule.memberModule != null
                ? PRFLocalMemberModule(
                    ulid: courseModule.memberModule!.ulid,
                    percentComplete: courseModule.memberModule!.percentComplete,
                    completionStatus:
                        courseModule.memberModule!.completionStatus,
                    createdAt: courseModule.memberModule!.createdAt,
                    updatedAt: courseModule.memberModule!.updatedAt,
                    completedAt: courseModule.memberModule!.completedAt,
                  )
                : null,
            module: PRFLocalModule(
              ulid: courseModule.module!.ulid,
              name: courseModule.module!.name,
              description: courseModule.module!.description,
              createdAt: courseModule.module!.createdAt,
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
            ),
          ),
        );
      }
    });

    for (final courseModule in courseModules) {
      if (courseModule.module?.lessonModules != null) {
        await persistLessonModules(
          lessonModules: courseModule.module!.lessonModules!,
        );
      }
    }
  }

  @override
  Stream<List<PRFLocalCourseModule>> getCourseModules({
    required String courseUlid,
  }) async* {
    await for (final localCourseModule in prfDBInstance.pRFLocalCourseModules
        .filter()
        .courseUlidEqualTo(courseUlid)
        .sortByOrder()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
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
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
      yield localCourseModule.first;
    }
  }

  @override
  Future<void> persistLessonModules({
    required List<PRFLessonModule> lessonModules,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final lessonModule in lessonModules) {
        Logger().d(lessonModule);
        await prfDBInstance.pRFLocalLessonModules.put(
          PRFLocalLessonModule(
            ulid: lessonModule.ulid,
            order: lessonModule.order,
            lessonUlid: lessonModule.lesson!.ulid,
            moduleUlid: lessonModule.module!.ulid,
            createdAt: lessonModule.createdAt,
            lessonMember: lessonModule.lessonMember != null
                ? PRFLocalLessonMember(
                    ulid: lessonModule.lessonMember!.ulid,
                    completionStatus:
                        lessonModule.lessonMember!.completionStatus,
                    createdAt: lessonModule.lessonMember!.createdAt,
                    completedAt: lessonModule.lessonMember!.completedAt,
                  )
                : null,
            lesson: PRFLocalLesson(
              ulid: lessonModule.lesson!.ulid,
              name: lessonModule.lesson!.name,
              description: lessonModule.lesson!.description,
              type: lessonModule.lesson!.type,
              createdAt: lessonModule.lesson!.createdAt,
              content: lessonModule.lesson!.content,
              videoUrl: lessonModule.lesson!.videoUrl,
              audioUrl: lessonModule.lesson!.audioUrl,
              documentUrl: lessonModule.lesson!.documentUrl,
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
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalLessonModule>> getLessonModules({
    required String moduleUlid,
  }) async* {
    await for (final localLessonModule in prfDBInstance.pRFLocalLessonModules
        .filter()
        .moduleUlidEqualTo(moduleUlid)
        .sortByOrder()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
      yield localLessonModule;
    }
  }

  @override
  Future<void> persistStudentEnquiries({
    required List<PRFStudentEnquiry> enquiries,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final enquiry in enquiries) {
        await prfDBInstance.pRFLocalStudentEnquirys.put(
          PRFLocalStudentEnquiry(
            ulid: enquiry.ulid,
            content: enquiry.content,
            createdAt: enquiry.createdAt,
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalStudentEnquiry>> getStudentEnquiries() async* {
    await for (final localEnquiry in prfDBInstance.pRFLocalStudentEnquirys
        .filter()
        .idGreaterThan(0)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
      yield localEnquiry;
    }
  }

  @override
  Future<void> persistStudentEnquiryReplies({
    required String studentEnquiryUlid,
    required List<PRFStudentEnquiryReply> replies,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final reply in replies) {
        await prfDBInstance.pRFLocalStudentEnquiryReplys.put(
          PRFLocalStudentEnquiryReply(
            ulid: reply.ulid,
            studentEnquiryUlid: studentEnquiryUlid,
            content: reply.content,
            createdAt: reply.createdAt,
            commentorableType: reply.commentorableType,
            isStudent: PRFMorphType.fromAPIKey(reply.commentorableType) ==
                PRFMorphType.student,
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalStudentEnquiryReply>> getStudentEnquiryReplies({
    required String studentEnquiryUlid,
  }) async* {
    await for (final localReply in prfDBInstance.pRFLocalStudentEnquiryReplys
        .filter()
        .studentEnquiryUlidEqualTo(studentEnquiryUlid)
        .sortByCreatedAt()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
      yield localReply;
    }
  }

  @override
  Future<void> persistAnnouncements({
    required List<PRFAnnouncement> announcements,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final announcement in announcements) {
        await prfDBInstance.pRFLocalAnnouncements.put(
          PRFLocalAnnouncement(
            ulid: announcement.ulid,
            title: announcement.title,
            content: announcement.content,
            createdAt: announcement.createdAt,
            updatedAt: announcement.updatedAt,
            publishedAt: announcement.publishedAt,
          ),
        );
      }
    });
  }

  @override
  Stream<Map<DateTime, List<PRFLocalAnnouncement>>> getAnnouncements() async* {
    await for (final localAnnouncement in prfDBInstance.pRFLocalAnnouncements
        .filter()
        .idGreaterThan(0)
        .sortByPublishedAtDesc()
        .build()
        .watch(fireImmediately: true)
        .asBroadcastStream()) {
      final groupedEntries = collection.groupBy<PRFLocalAnnouncement, DateTime>(
        localAnnouncement.toList(),
        (PRFLocalAnnouncement entry) => entry.publishedAt,
      );

      yield groupedEntries;
    }
  }

  @override
  Future<void> persistPrayerResponses({
    required List<PRFPrayerResponseDTO> prayerResponses,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final prayerResponse in prayerResponses) {
        await prfDBInstance.pRFLocalPrayerResponses.put(
          PRFLocalPrayerResponse(
            memberUlid: prayerResponse.memberUlid,
            prayerPromptUlid: prayerResponse.prayerPromptUlid,
          ),
        );
      }
    });
  }

  @override
  List<PRFPrayerResponseDTO> retrievePrayerResponses() {
    final responses = prfDBInstance.pRFLocalPrayerResponses
        .filter()
        .idGreaterThan(0)
        .build()
        .findAllSync();
    return responses
        .map<PRFPrayerResponseDTO>(
          (response) => PRFPrayerResponseDTO(
            prayerPromptUlid: response.prayerPromptUlid,
            memberUlid: response.memberUlid,
          ),
        )
        .toList();
  }

  @override
  void deletePrayerResponse({required String prayerPromptUlid}) {
    prfDBInstance.writeTxnSync(() async {
      prfDBInstance.pRFLocalPrayerResponses
          .filter()
          .prayerPromptUlidEqualTo(prayerPromptUlid)
          .deleteFirstSync();
    });
  }
}
