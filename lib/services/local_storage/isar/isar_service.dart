import 'package:app/models/local/prf_announcement.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:app/models/local/prf_course_module.dart';
import 'package:app/models/local/prf_debrief_note.dart';
import 'package:app/models/local/prf_failed_recording_upload.dart';
import 'package:app/models/local/prf_faq.dart';
import 'package:app/models/local/prf_faq_category.dart';
import 'package:app/models/local/prf_lesson_module.dart';
import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/models/local/prf_media_upload.dart';
import 'package:app/models/local/prf_member_mission.dart';
import 'package:app/models/local/prf_mission.dart';
import 'package:app/models/local/prf_mission_question.dart';
import 'package:app/models/local/prf_mission_session.dart';
import 'package:app/models/local/prf_prayer_response.dart';
import 'package:app/models/local/prf_soul.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/services/local_storage/isar/announcement_db_service.dart';
import 'package:app/services/local_storage/isar/course_db_service.dart';
import 'package:app/services/local_storage/isar/course_module_db_service.dart';
import 'package:app/services/local_storage/isar/debrief_note_db_service.dart';
import 'package:app/services/local_storage/isar/faq_category_db_service.dart';
import 'package:app/services/local_storage/isar/faq_db_service.dart';
import 'package:app/services/local_storage/isar/lesson_module_db_service.dart';
import 'package:app/services/local_storage/isar/media_dto_db_service.dart';
import 'package:app/services/local_storage/isar/member_mission_db_service.dart';
import 'package:app/services/local_storage/isar/mission_db_service.dart';
import 'package:app/services/local_storage/isar/mission_question_db_service.dart';
import 'package:app/services/local_storage/isar/mission_session_db_service.dart';
import 'package:app/services/local_storage/isar/mission_subscription_db_service.dart';
import 'package:app/services/local_storage/isar/prayer_response_db_service.dart';
import 'package:app/services/local_storage/isar/soul_db_service.dart';
import 'package:app/services/local_storage/isar/student_enquiry_db_service.dart';
import 'package:app/services/local_storage/isar/student_enquiry_reply_db_service.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class IsarService {
  factory IsarService() => instance ??= IsarService._();
  IsarService._();

  static IsarService? instance;

  late final Isar prfDBInstance;

  late final AnnouncementDbService _announcements;
  AnnouncementDbService get announcements => _announcements;

  late final CourseDbService _courses;
  CourseDbService get courses => _courses;

  late final CourseModuleDbService _courseModules;
  CourseModuleDbService get courseModules => _courseModules;

  late final DebriefNoteDbService _debriefNotes;
  DebriefNoteDbService get debriefNotes => _debriefNotes;

  late final FaqCategoryDbService _faqCategories;
  FaqCategoryDbService get faqCategories => _faqCategories;

  late final FaqDbService _faqs;
  FaqDbService get faqs => _faqs;

  late final LessonModuleDbService _lessonModules;
  LessonModuleDbService get lessonModules => _lessonModules;

  late final MediaDTODbService _mediaUploads;
  MediaDTODbService get mediaUploads => _mediaUploads;

  late final MemberMissionDbService _memberMissions;
  MemberMissionDbService get memberMissions => _memberMissions;

  late final MissionDbService _missions;
  MissionDbService get missions => _missions;

  late final MissionQuestionDbService _missionQuestions;
  MissionQuestionDbService get missionQuestions => _missionQuestions;

  late final MissionSessionDbService _missionSessions;
  MissionSessionDbService get missionSessions => _missionSessions;

  late final MissionSubscriptionDbService _missionSubscriptions;
  MissionSubscriptionDbService get missionSubscriptions =>
      _missionSubscriptions;

  late final PrayerResponseDbService _prayerResponses;
  PrayerResponseDbService get prayerResponses => _prayerResponses;

  late final SoulDbService _souls;
  SoulDbService get souls => _souls;

  late final StudentEnquiryDbService _studentEnquiries;
  StudentEnquiryDbService get studentEnquiries => _studentEnquiries;

  late final StudentEnquiryReplyDbService _studentEnquiryReplies;
  StudentEnquiryReplyDbService get studentEnquiryReplies =>
      _studentEnquiryReplies;

  Future<void> initDatabase() async {
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
      PRFFailedRecordingUploadSchema,
      PRFLocalFaqSchema,
      PRFLocalFaqCategorySchema,
      PRFLocalMissionSchema,
      PRFLocalMissionSubscriptionSchema,
      PRFLocalDebriefNoteSchema,
      PRFLocalMissionQuestionSchema,
      PRFLocalSoulSchema,
      PRFLocalMissionSessionSchema,
      PRFLocalMemberMissionSchema,
    ];

    prfDBInstance = await Isar.open(schemas, directory: dir.path);

    _announcements = AnnouncementDbService(prfDBInstance: prfDBInstance);
    _courses = CourseDbService(prfDBInstance: prfDBInstance);
    _courseModules = CourseModuleDbService(prfDBInstance: prfDBInstance);
    _debriefNotes = DebriefNoteDbService(prfDBInstance: prfDBInstance);
    _faqCategories = FaqCategoryDbService(prfDBInstance: prfDBInstance);
    _faqs = FaqDbService(prfDBInstance: prfDBInstance);
    _lessonModules = LessonModuleDbService(prfDBInstance: prfDBInstance);
    _mediaUploads = MediaDTODbService(prfDBInstance: prfDBInstance);

    _memberMissions = MemberMissionDbService(prfDBInstance: prfDBInstance);
    _missions = MissionDbService(prfDBInstance: prfDBInstance);
    _missionQuestions = MissionQuestionDbService(prfDBInstance: prfDBInstance);
    _missionSessions = MissionSessionDbService(prfDBInstance: prfDBInstance);
    _missionSubscriptions = MissionSubscriptionDbService(
      prfDBInstance: prfDBInstance,
    );
    _prayerResponses = PrayerResponseDbService(prfDBInstance: prfDBInstance);
    _souls = SoulDbService(prfDBInstance: prfDBInstance);
    _studentEnquiries = StudentEnquiryDbService(prfDBInstance: prfDBInstance);
    _studentEnquiryReplies = StudentEnquiryReplyDbService(
      prfDBInstance: prfDBInstance,
    );
  }

  Future<void> clearAllTables() async {
    await prfDBInstance.writeTxn(() async {
      await prfDBInstance.clear();
    });
  }
}
