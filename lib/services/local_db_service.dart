import 'dart:async';

import 'package:app/enums/prf_morph_types.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_debrief_note.dart';
import 'package:app/models/local/prf_faq.dart';
import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/models/local/prf_local_member_mission_subscription.dart';
import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/models/local/prf_media_upload.dart';
import 'package:app/models/local/prf_mission.dart';
import 'package:app/models/local/prf_mission_question.dart';
import 'package:app/models/local/prf_mission_session.dart';
import 'package:app/models/local/prf_prayer_response.dart';
import 'package:app/models/local/prf_soul.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_faq.dart';
import 'package:app/models/remote/prf_faq_category.dart';
import 'package:app/models/remote/prf_lesson_module.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/models/remote/prf_soul.dart';
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

  Future<void> persistCourses({required List<PRFCourse> courses});
  Stream<List<PRFLocalCourse>> getCourses();
  Stream<PRFLocalCourse> getCourse({required String courseUlid});

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
  Stream<List<PRFLocalStudentEnquiry>> getStudentEnquiries({
    bool replyStatus = false,
  });

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
  void deletePrayerResponse({required String prayerPromptUlid});

  Future<void> persistMediaUploads({required List<PRFMediaDTO> mediaDTOs});
  List<PRFMediaDTO> retrieveMediaUploads();
  void deleteMediaUpload({required String modelUlid, required String path});

  Future<void> persistFaqs({required List<PRFFaq> faqs});
  Future<List<PRFLocalFaq>> retreiveFaqs({String? categoryUlid, String? query});

  Future<void> persistFaqCategories({
    required List<PRFFaqCategory> faqCategories,
  });
  Future<List<PRFLocalFaqCategory>> retreiveFaqCategories();

  Future<void> persistMissions({required List<PRFMission> missions});
  Stream<List<PRFLocalMission>> get missions;
  Future<void> refreshMissions();
  Stream<PRFLocalMission> getMission({required String missionUlid});

  Future<void> persistMemberMissions({
    required List<PRFMissionSubscription> missionSubscriptions,
  });
  Stream<List<PRFLocalMission>> get memberMissions;
  Future<void> refreshMemberMissions();

  Future<void> persistMissionSubscriptions({
    required List<PRFMissionSubscription> missionSubscriptions,
    required String missionUlid,
  });
  Stream<List<PRFLocalMissionSubscription>> getMissionSubscriptions({
    required String missionUlid,
  });

  Future<void> persistMissionQuestions({
    required List<PRFMissionQuestion> missionQuestions,
    required String missionUlid,
  });
  Stream<List<PRFLocalMissionQuestion>> getMissionQuestions({
    required String missionUlid,
  });

  Future<void> persistDebriefNotes({
    required List<PRFDebriefNote> debriefNotes,
    required String missionUlid,
  });
  Stream<List<PRFLocalDebriefNote>> getDebriefNotes({
    required String missionUlid,
  });

  Future<void> persistSouls({
    required List<PRFSoul> souls,
    required String missionUlid,
  });
  Stream<List<PRFLocalSoul>> getSouls({required String missionUlid});
  Future<void> persistMissionSessions({
    required List<PRFMissionSession> missionSessions,
    required String missionUlid,
  });
  Stream<Map<DateTime, List<PRFLocalMissionSession>>> getMissionSessions({
    required String missionUlid,
  });
  Future<void> getMissionSession({required String missionSessionUlid});
  Stream<PRFLocalMissionSession> get missionSession;
  Future<void> deleteMissionSession({required String missionSessionUlid});
}

class LocalDBServiceImpl implements LocalDBService {
  @override
  Future<Isar> initDatabase() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final schemas = [
      PRFLocalCourseSchema,
      PRFLocalCourseModuleSchema,
      PRFLocalLessonModuleSchema,
      PRFLocalStudentEnquirySchema,
      PRFLocalStudentEnquiryReplySchema,
      PRFLocalAnnouncementSchema,
      PRFLocalPrayerResponseSchema,
      PRFLocalMediaUploadSchema,
      PRFLocalFaqSchema,
      PRFLocalFaqCategorySchema,
      PRFLocalMissionSchema,
      PRFLocalMemberMissionSubscriptionSchema,
      PRFLocalMissionSubscriptionSchema,
      PRFLocalDebriefNoteSchema,
      PRFLocalMissionQuestionSchema,
      PRFLocalSoulSchema,
      PRFLocalMissionSessionSchema,
    ];

    return Isar.open(schemas, directory: dir.path);
  }

  @override
  Future<void> clearAllTables() async {
    await prfDBInstance.writeTxn(() async {
      await prfDBInstance.clear();
    });
  }

  @override
  Future<void> persistCourses({required List<PRFCourse> courses}) async {
    await prfDBInstance.writeTxn(() async {
      for (final course in courses) {
        await prfDBInstance.pRFLocalCourses.put(
          PRFLocalCourse(
            ulid: course.ulid,
            name: course.name,
            description: course.description,
            createdAt: course.createdAt,
            thumbnail:
                course.thumbnail != null
                    ? PRFLocalMedia(
                      collectionName: course.thumbnail!.collectionName,
                      fileName: course.thumbnail!.fileName,
                      temporaryURL: course.thumbnail!.temporaryURL,
                      size: course.thumbnail!.size,
                      humanReadableSize: course.thumbnail!.humanReadableSize,
                      mimeType: course.thumbnail!.mimeType,
                      name: course.thumbnail!.name,
                      createdAt: course.thumbnail!.createdAt,
                      updatedAt: course.thumbnail!.updatedAt,
                    )
                    : null,
            courseMember:
                course.courseMember != null
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
    await for (final localCourse
        in prfDBInstance.pRFLocalCourses
            .filter()
            .idGreaterThan(0)
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localCourse;
    }
  }

  @override
  Stream<PRFLocalCourse> getCourse({required String courseUlid}) async* {
    await for (final localCourse
        in prfDBInstance.pRFLocalCourses
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
            memberModule:
                courseModule.memberModule != null
                    ? PRFLocalMemberModule(
                      ulid: courseModule.memberModule!.ulid,
                      percentComplete:
                          courseModule.memberModule!.percentComplete,
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
              thumbnail:
                  courseModule.module!.thumbnail != null
                      ? PRFLocalMedia(
                        collectionName:
                            courseModule.module!.thumbnail!.collectionName,
                        fileName: courseModule.module!.thumbnail!.fileName,
                        temporaryURL:
                            courseModule.module!.thumbnail!.temporaryURL,
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
    await for (final localCourseModule
        in prfDBInstance.pRFLocalCourseModules
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
    await for (final localCourseModule
        in prfDBInstance.pRFLocalCourseModules
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
            lessonMember:
                lessonModule.lessonMember != null
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
              audios:
                  lessonModule.lesson!.audios
                      ?.map(
                        (audio) => PRFLocalMedia(
                          collectionName: audio.collectionName,
                          fileName: audio.fileName,
                          temporaryURL: audio.temporaryURL,
                          size: audio.size,
                          humanReadableSize: audio.humanReadableSize,
                          mimeType: audio.mimeType,
                          name: audio.name,
                          createdAt: audio.createdAt,
                          updatedAt: audio.updatedAt,
                        ),
                      )
                      .toList(),
              documents:
                  lessonModule.lesson!.documents
                      ?.map(
                        (document) => PRFLocalMedia(
                          collectionName: document.collectionName,
                          fileName: document.fileName,
                          temporaryURL: document.temporaryURL,
                          size: document.size,
                          humanReadableSize: document.humanReadableSize,
                          mimeType: document.mimeType,
                          name: document.name,
                          createdAt: document.createdAt,
                          updatedAt: document.updatedAt,
                        ),
                      )
                      .toList(),
              videos:
                  lessonModule.lesson!.videos
                      ?.map(
                        (video) => PRFLocalMedia(
                          collectionName: video.collectionName,
                          fileName: video.fileName,
                          temporaryURL: video.temporaryURL,
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
    await for (final localLessonModule
        in prfDBInstance.pRFLocalLessonModules
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
            hasReplies: enquiry.hasReplies,
            content: enquiry.content,
            createdAt: enquiry.createdAt,
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalStudentEnquiry>> getStudentEnquiries({
    bool replyStatus = false,
  }) async* {
    await for (final localEnquiry
        in prfDBInstance.pRFLocalStudentEnquirys
            .filter()
            .hasRepliesEqualTo(replyStatus)
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
            isStudent: reply.commentorableType == PRFMorphType.student,
          ),
        );
      }
    });
  }

  @override
  Stream<List<PRFLocalStudentEnquiryReply>> getStudentEnquiryReplies({
    required String studentEnquiryUlid,
  }) async* {
    await for (final localReply
        in prfDBInstance.pRFLocalStudentEnquiryReplys
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
    await for (final localAnnouncement
        in prfDBInstance.pRFLocalAnnouncements
            .filter()
            .idGreaterThan(0)
            .sortByPublishedAt()
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
    final responses =
        prfDBInstance.pRFLocalPrayerResponses
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

  @override
  Future<void> persistMediaUploads({
    required List<PRFMediaDTO> mediaDTOs,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final mediaDTO in mediaDTOs) {
        await prfDBInstance.pRFLocalMediaUploads.put(
          PRFLocalMediaUpload(
            modelUlid: mediaDTO.modelUlid,
            model: mediaDTO.model,
            path: mediaDTO.path,
          ),
        );
      }
    });
  }

  @override
  List<PRFMediaDTO> retrieveMediaUploads() {
    final responses =
        prfDBInstance.pRFLocalMediaUploads
            .filter()
            .idGreaterThan(0)
            .build()
            .findAllSync();
    return responses
        .map<PRFMediaDTO>(
          (response) => PRFMediaDTO(
            modelUlid: response.modelUlid,
            model: response.model,
            path: response.path,
            name: Misc.getFileName(response.path),
          ),
        )
        .toList();
  }

  @override
  void deleteMediaUpload({required String modelUlid, required String path}) {
    prfDBInstance.writeTxnSync(() async {
      prfDBInstance.pRFLocalMediaUploads
          .filter()
          .modelUlidEqualTo(modelUlid)
          .pathEqualTo(path)
          .deleteFirstSync();
    });
  }

  @override
  Future<void> persistFaqCategories({
    required List<PRFFaqCategory> faqCategories,
  }) async {
    await prfDBInstance.writeTxn(() async {
      for (final faqCategory in faqCategories) {
        await prfDBInstance.pRFLocalFaqCategorys.put(
          PRFLocalFaqCategory(ulid: faqCategory.ulid, name: faqCategory.name),
        );
      }
    });
  }

  @override
  Future<void> persistFaqs({required List<PRFFaq> faqs}) async {
    await prfDBInstance.writeTxn(() async {
      for (final faq in faqs) {
        await prfDBInstance.pRFLocalFaqs.put(
          PRFLocalFaq(
            ulid: faq.ulid,
            question: faq.question,
            answer: faq.answer,
            categoryUlid: faq.category!.ulid,
          ),
        );
      }
    });
  }

  @override
  Future<List<PRFLocalFaqCategory>> retreiveFaqCategories() async {
    return prfDBInstance.pRFLocalFaqCategorys.where().findAll();
  }

  @override
  Future<List<PRFLocalFaq>> retreiveFaqs({
    String? categoryUlid,
    String? query,
  }) async {
    return prfDBInstance.pRFLocalFaqs
        .where()
        .filter()
        .optional(
          categoryUlid != null,
          (q) => q.categoryUlidEqualTo(categoryUlid!),
        )
        .optional(
          query != null,
          (q) => q
              .questionWordsElementContains(query!)
              .answerWordsElementContains(query),
        )
        .findAll();
  }

  @override
  Stream<PRFLocalMission> getMission({required String missionUlid}) async* {
    await for (final localMission
        in prfDBInstance.pRFLocalMissions
            .filter()
            .ulidEqualTo(missionUlid)
            .sortByCreatedAt()
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localMission.first;
    }
  }

  final _missionsController =
      StreamController<List<PRFLocalMission>>.broadcast();

  @override
  Future<void> refreshMissions() async {
    final missions =
        await prfDBInstance.pRFLocalMissions
            .filter()
            .loggedInMemberMissionSubscriptionIsNull()
            .sortByStartDate()
            .build()
            .findAll();

    _missionsController.add(missions);
  }

  @override
  Stream<List<PRFLocalMission>> get missions => _missionsController.stream;

  @override
  Future<void> persistMissions({required List<PRFMission> missions}) async {
    await prfDBInstance.writeTxn(() async {
      for (final mission in missions) {
        await prfDBInstance.pRFLocalMissions.put(
          _transformRemoteMissionToLocalMission(mission),
        );
      }
    });
  }

  PRFLocalMission _transformRemoteMissionToLocalMission(PRFMission mission) {
    final missionType = mission.missionType!;
    final school = mission.school!;
    final contacts = mission.school!.contacts!;
    final weatherForecasts = mission.weatherForecasts;

    return PRFLocalMission(
      ulid: mission.ulid,
      startDate: mission.startDate,
      startTime: mission.startTime,
      endDate: mission.endDate,
      endTime: mission.endTime,
      missionPrepNotes: mission.missionPrepNotes,
      theme: mission.theme,
      capacity: mission.capacity,
      status: mission.status,
      missionSubscriptionsNeeded: mission.missionSubscriptionsNeeded,
      createdAt: mission.createdAt,
      updatedAt: mission.updatedAt,
      missionType: PRFLocalMissionType(
        ulid: missionType.ulid,
        name: missionType.name,
        isActive: missionType.isActive,
        createdAt: missionType.createdAt,
        updatedAt: missionType.updatedAt,
      ),
      school: PRFLocalSchool(
        ulid: school.ulid,
        name: school.name,
        address: school.address,
        staticDuration: school.staticDuration,
        totalStudents: school.totalStudents,
        createdAt: school.createdAt,
        updatedAt: school.updatedAt,
        description: school.description,
        directions: school.directions,
        distance: school.distance,
        latitude: school.latitude,
        longitude: school.longitude,
        contacts:
            contacts
                .map(
                  (contact) => PRFLocalContact(
                    ulid: contact.ulid,
                    name: contact.name,
                    phone: contact.phone,
                    contactType: PRFLocalContactType(
                      ulid: contact.contactType!.ulid,
                      name: contact.contactType!.name,
                    ),
                  ),
                )
                .toList(),
      ),
      weatherForecasts:
          weatherForecasts
              .map(
                (weatherForecast) => PRFLocalWeatherForecast(
                  ulid: weatherForecast.ulid,
                  forecastDate: weatherForecast.forecastDate,
                  weatherCodeDescription:
                      weatherForecast.weatherCodeDescription,
                  temperature: PRFLocalTemperature(
                    apparentAvg: weatherForecast.temperature.apparentAvg,
                    apparentMin: weatherForecast.temperature.apparentMin,
                    apparentMax: weatherForecast.temperature.apparentMax,
                    avg: weatherForecast.temperature.avg,
                    min: weatherForecast.temperature.min,
                    max: weatherForecast.temperature.max,
                  ),
                  visibility: PRFLocalVisibility(
                    avg: weatherForecast.visibility.avg,
                    min: weatherForecast.visibility.min,
                    max: weatherForecast.visibility.max,
                  ),
                  precipitationProbability: PRFLocalPrecipitationProbability(
                    avg: weatherForecast.precipitationProbability.avg,
                    min: weatherForecast.precipitationProbability.min,
                    max: weatherForecast.precipitationProbability.max,
                  ),
                  humidity: PRFLocalHumidity(
                    avg: weatherForecast.humidity.avg,
                    min: weatherForecast.humidity.min,
                    max: weatherForecast.humidity.max,
                  ),
                  dressingRecommendations:
                      weatherForecast.dressingRecommendations,
                  activityRecommendations:
                      weatherForecast.activityRecommendations,
                ),
              )
              .toList(),
    );
  }

  Future<PRFLocalMission?> _getMission(String missionUlid) {
    return prfDBInstance.pRFLocalMissions
        .where()
        .ulidEqualTo(missionUlid)
        .findFirst();
  }

  @override
  Stream<List<PRFLocalMission>> get memberMissions =>
      _memberMissionsController.stream;

  final _memberMissionsController =
      StreamController<List<PRFLocalMission>>.broadcast();

  @override
  Future<void> refreshMemberMissions() async {
    final missions =
        await prfDBInstance.pRFLocalMissions
            .filter()
            .loggedInMemberMissionSubscriptionIsNotNull()
            .sortByStartDate()
            .build()
            .findAll(); // Get latest data

    _memberMissionsController.add(missions); // Push new data into the stream
  }

  @override
  Future<void> persistMemberMissions({
    required List<PRFMissionSubscription> missionSubscriptions,
  }) async {
    Logger().i('persistMemberMissions :: Start');
    await prfDBInstance.writeTxn(() async {
      for (final missionSubscription in missionSubscriptions) {
        await prfDBInstance.pRFLocalMemberMissionSubscriptions.put(
          PRFLocalMemberMissionSubscription(
            ulid: missionSubscription.ulid,
            missionRole: missionSubscription.missionRole,
            status: missionSubscription.status,
            missionUlid: missionSubscription.mission!.ulid,
          ),
        );

        Logger().i('persistMemberMissions :: Persisted');

        var mission = await _getMission(missionSubscription.mission!.ulid);
        Logger().i('persistMemberMissions :: Result ${mission?.ulid}');

        if (mission == null) {
          Logger().i('persistMemberMissions :: Persisiting mission');
          // Persist that mission if it doesn't exist
          await prfDBInstance.pRFLocalMissions.put(
            _transformRemoteMissionToLocalMission(missionSubscription.mission!),
          );

          mission = await _getMission(missionSubscription.mission!.ulid);
        }

        mission!.loggedInMemberMissionSubscription =
            PRFLocalMissionMemberSubscription(
              ulid: missionSubscription.ulid,
              status: missionSubscription.status,
              missionRole: missionSubscription.missionRole,
              createdAt: missionSubscription.createdAt,
              updatedAt: missionSubscription.updatedAt,
            );

        Logger().i('persistMemberMissions :: Updated ${mission.ulid}');

        await prfDBInstance.pRFLocalMissions.put(mission);

        Logger().i('persistMemberMissions :: End ${mission.ulid}');
      }
    });
    Logger().i('persistMemberMissions :: End');
  }

  @override
  Stream<List<PRFLocalMissionSubscription>> getMissionSubscriptions({
    required String missionUlid,
  }) async* {
    await for (final localMissionSubscription
        in prfDBInstance.pRFLocalMissionSubscriptions
            .filter()
            .missionUlidEqualTo(missionUlid)
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localMissionSubscription;
    }
  }

  @override
  Future<void> persistMissionSubscriptions({
    required List<PRFMissionSubscription> missionSubscriptions,
    required String missionUlid,
  }) async {
    Logger().i('persistMissionSubscriptions :: Start');
    await prfDBInstance.writeTxn(() async {
      for (final missionSubscription in missionSubscriptions) {
        await prfDBInstance.pRFLocalMissionSubscriptions.put(
          PRFLocalMissionSubscription(
            ulid: missionSubscription.ulid,
            missionRole: missionSubscription.missionRole,
            status: missionSubscription.status,
            member: PRFLocalMember(
              ulid: missionSubscription.member!.ulid,
              fullName: missionSubscription.member!.fullName,
              phoneNumber: missionSubscription.member!.phoneNumber,
            ),
            missionUlid: missionUlid,
          ),
        );

        Logger().i('persistMissionSubscriptions :: Persisted');
      }
    });
  }

  @override
  Stream<List<PRFLocalDebriefNote>> getDebriefNotes({
    required String missionUlid,
  }) async* {
    await for (final localDebriefNotes
        in prfDBInstance.pRFLocalDebriefNotes
            .filter()
            .missionUlidEqualTo(missionUlid)
            .sortByCreatedAtDesc()
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localDebriefNotes;
    }
  }

  @override
  Stream<List<PRFLocalMissionQuestion>> getMissionQuestions({
    required String missionUlid,
  }) async* {
    await for (final localMissionQuestions
        in prfDBInstance.pRFLocalMissionQuestions
            .filter()
            .missionUlidEqualTo(missionUlid)
            .sortByCreatedAtDesc()
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localMissionQuestions;
    }
  }

  @override
  Future<void> persistDebriefNotes({
    required List<PRFDebriefNote> debriefNotes,
    required String missionUlid,
  }) async {
    Logger().i('persistDebriefNotes :: Start');
    await prfDBInstance.writeTxn(() async {
      for (final debriefNote in debriefNotes) {
        await prfDBInstance.pRFLocalDebriefNotes.put(
          PRFLocalDebriefNote(
            ulid: debriefNote.ulid,
            note: debriefNote.note,
            createdAt: debriefNote.createdAt,
            missionUlid: missionUlid,
          ),
        );

        Logger().i('persistDebriefNotes :: Persisted');
      }
    });
  }

  @override
  Future<void> persistMissionQuestions({
    required List<PRFMissionQuestion> missionQuestions,
    required String missionUlid,
  }) async {
    Logger().i('persistMissionQuestions :: Start');
    await prfDBInstance.writeTxn(() async {
      for (final missionQuestion in missionQuestions) {
        await prfDBInstance.pRFLocalMissionQuestions.put(
          PRFLocalMissionQuestion(
            ulid: missionQuestion.ulid,
            question: missionQuestion.question,
            createdAt: missionQuestion.createdAt,
            missionUlid: missionUlid,
          ),
        );

        Logger().i('persistMissionQuestions :: Persisted');
      }
    });
  }

  @override
  Stream<List<PRFLocalSoul>> getSouls({required String missionUlid}) async* {
    await for (final localMissionQuestions
        in prfDBInstance.pRFLocalSouls
            .filter()
            .missionUlidEqualTo(missionUlid)
            .sortByCreatedAtDesc()
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      yield localMissionQuestions;
    }
  }

  @override
  Future<void> persistSouls({
    required List<PRFSoul> souls,
    required String missionUlid,
  }) async {
    Logger().i('persistSouls :: Start');
    await prfDBInstance.writeTxn(() async {
      for (final soul in souls) {
        await prfDBInstance.pRFLocalSouls.put(
          PRFLocalSoul(
            ulid: soul.ulid,
            createdAt: soul.createdAt,
            missionUlid: missionUlid,
            fullName: soul.fullName,
            classGroup: PRFLocalClassGroup(
              ulid: soul.classGroup?.ulid,
              name: soul.classGroup?.name,
            ),
          ),
        );

        Logger().i('persistSouls :: Persisted');
      }
    });
  }

  @override
  Stream<Map<DateTime, List<PRFLocalMissionSession>>> getMissionSessions({
    required String missionUlid,
  }) async* {
    await for (final localMissionSessions
        in prfDBInstance.pRFLocalMissionSessions
            .filter()
            .missionUlidEqualTo(missionUlid)
            .sortByStartsAt()
            .build()
            .watch(fireImmediately: true)
            .asBroadcastStream()) {
      final groupedSessions = collection
          .groupBy<PRFLocalMissionSession, DateTime>(
            localMissionSessions,
            (session) => DateTime(
              session.startsAt.year,
              session.startsAt.month,
              session.startsAt.day,
            ),
          );

      yield groupedSessions;
    }
  }

  @override
  Future<void> persistMissionSessions({
    required List<PRFMissionSession> missionSessions,
    required String missionUlid,
  }) async {
    Logger().i('persistMissionSessions :: Start');
    await prfDBInstance.writeTxn(() async {
      if (missionSessions.length == 1) {
        await prfDBInstance.pRFLocalMissionSessions.put(
          _transformRemoteMissionSessionToLocalMissionSession(
            missionSessions[0],
            missionUlid,
          ),
        );
      }

      if (missionSessions.length > 1) {
        for (final missionSession in missionSessions) {
          await prfDBInstance.pRFLocalMissionSessions.put(
            _transformRemoteMissionSessionToLocalMissionSession(
              missionSession,
              missionUlid,
            ),
          );

          Logger().i('persistMissionSessions :: Persisted');
        }
      }
    });
  }

  PRFLocalMissionSession _transformRemoteMissionSessionToLocalMissionSession(
    PRFMissionSession missionSession,
    String missionUlid,
  ) => PRFLocalMissionSession(
    missionUlid: missionUlid,
    ulid: missionSession.ulid,
    startsAt: missionSession.startsAt,
    endsAt: missionSession.endsAt,
    notes: missionSession.notes,
    order: missionSession.order,
    facilitator: PRFLocalMember(
      ulid: missionSession.facilitator?.ulid,
      fullName: missionSession.facilitator?.fullName,
      phoneNumber: missionSession.facilitator?.phoneNumber,
    ),
    speaker: PRFLocalMember(
      ulid: missionSession.speaker?.ulid,
      fullName: missionSession.speaker?.fullName,
      phoneNumber: missionSession.speaker?.phoneNumber,
    ),

    classGroup: PRFLocalClassGroup(
      ulid: missionSession.classGroup?.ulid,
      name: missionSession.classGroup?.name,
    ),
    transcripts:
        missionSession.transcripts
            .map(
              (transcript) => PRFLocalMissionSessionTranscript(
                ulid: transcript.ulid,
                content: transcript.content,
                media: PRFLocalMedia(
                  collectionName: transcript.media?.collectionName,
                  fileName: transcript.media?.fileName,
                  temporaryURL: transcript.media?.temporaryURL,
                  size: transcript.media?.size,
                  humanReadableSize: transcript.media?.humanReadableSize,
                  mimeType: transcript.media?.mimeType,
                  name: transcript.media?.name,
                  createdAt: transcript.media?.createdAt,
                  updatedAt: transcript.media?.updatedAt,
                ),
              ),
            )
            .toList(),
  );

  final _missionSessionController =
      StreamController<PRFLocalMissionSession>.broadcast();

  @override
  Future<void> getMissionSession({required String missionSessionUlid}) async {
    final missionSession =
        await prfDBInstance.pRFLocalMissionSessions
            .filter()
            .ulidEqualTo(missionSessionUlid)
            .build()
            .findFirst();

    Logger().i(missionSession);

    if (missionSession != null) {
      _missionSessionController.add(missionSession);
    }
  }

  @override
  Stream<PRFLocalMissionSession> get missionSession =>
      _missionSessionController.stream;

  @override
  Future<void> deleteMissionSession({
    required String missionSessionUlid,
  }) async {
    await prfDBInstance.writeTxn(() async {
      await prfDBInstance.pRFLocalMissionSessions
          .where()
          .ulidEqualTo(missionSessionUlid)
          .deleteAll();
    });
  }
}
