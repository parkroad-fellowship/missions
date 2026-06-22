import 'dart:convert';
import 'dart:typed_data';

import 'package:app/hive/hive_registrar.g.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/allocation_entry_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/announcement_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/class_group_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/course_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/course_module_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/debrief_note_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/event_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/event_subscription_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/expense_category_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/failed_recording_upload_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/faq_category_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/faq_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/lesson_module_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/media_upload_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/member_mission_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_ground_suggestion_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_question_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_session_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_subscription_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/payment_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/payment_type_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/prayer_request_db_service.dart';
import 'package:app/services/local_storage/hive/db/prayer_response_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/requisition_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/school_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/soul_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/student_enquiry_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/student_enquiry_reply_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/subscriptions_hive_db_service.dart';
import 'package:app/services/local_storage/hive/kv/auth_hive_service.dart';
import 'package:app/services/local_storage/hive/kv/settings_hive_service.dart';
import 'package:app/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveService {
  factory HiveService() => instance ??= HiveService._();
  HiveService._();

  static HiveService? instance;
  static const String _binaryAdapterMigrationMarker =
      'hive_binary_adapter_migration_v1';
  static const String _migrationMetaBoxName = 'hive_migration_meta';

  // ----- Auth / settings boxes -----

  late final AuthHiveService _auth;
  late final SettingsHiveService _settings;

  AuthHiveService get auth => _auth;
  SettingsHiveService get settings => _settings;

  // ----- Entity CRUD services -----

  late final AnnouncementHiveDbService _announcements;
  late final ClassGroupHiveDbService _classGroups;
  late final CourseHiveDbService _courses;
  late final CourseModuleHiveDbService _courseModules;
  late final LessonModuleHiveDbService _lessonModules;
  late final StudentEnquiryHiveDbService _studentEnquiries;
  late final StudentEnquiryReplyHiveDbService _studentEnquiryReplies;
  late final FaqHiveDbService _faqs;
  late final FaqCategoryHiveDbService _faqCategories;
  late final DebriefNoteHiveDbService _debriefNotes;
  late final MissionHiveDbService _missions;
  late final MissionQuestionHiveDbService _missionQuestions;
  late final MissionSessionHiveDbService _missionSessions;
  late final MissionSubscriptionHiveDbService _missionSubscriptions;
  late final SubscriptionHiveDbService _subscriptions;
  late final MemberMissionHiveDbService _memberMissions;
  late final PrayerResponseHiveDbService _prayerResponses;
  late final SoulHiveDbService _souls;
  late final MediaUploadHiveDbService _mediaUploads;
  late final FailedRecordingUploadHiveDbService _failedRecordingUploads;
  late final ExpenseCategoryHiveDbService _expenseCategories;
  late final PaymentTypeHiveDbService _paymentTypes;
  late final EventHiveDbService _events;
  late final EventSubscriptionHiveDbService _eventSubscriptions;
  late final PaymentHiveDbService _payments;
  late final PrayerRequestHiveDbService _prayerRequests;
  late final MissionGroundSuggestionHiveDbService _missionGroundSuggestions;
  late final RequisitionHiveDbService _requisitions;
  late final AllocationEntryHiveDbService _allocationEntries;
  late final SchoolHiveDbService _schools;

  AnnouncementHiveDbService get announcements => _announcements;
  ClassGroupHiveDbService get classGroups => _classGroups;
  CourseHiveDbService get courses => _courses;
  CourseModuleHiveDbService get courseModules => _courseModules;
  LessonModuleHiveDbService get lessonModules => _lessonModules;
  StudentEnquiryHiveDbService get studentEnquiries => _studentEnquiries;
  StudentEnquiryReplyHiveDbService get studentEnquiryReplies =>
      _studentEnquiryReplies;
  FaqHiveDbService get faqs => _faqs;
  FaqCategoryHiveDbService get faqCategories => _faqCategories;
  DebriefNoteHiveDbService get debriefNotes => _debriefNotes;
  MissionHiveDbService get missions => _missions;
  MissionQuestionHiveDbService get missionQuestions => _missionQuestions;
  MissionSessionHiveDbService get missionSessions => _missionSessions;
  MissionSubscriptionHiveDbService get missionSubscriptions =>
      _missionSubscriptions;
  SubscriptionHiveDbService get subscriptions => _subscriptions;
  MemberMissionHiveDbService get memberMissions => _memberMissions;
  PrayerResponseHiveDbService get prayerResponses => _prayerResponses;
  SoulHiveDbService get souls => _souls;
  MediaUploadHiveDbService get mediaUploads => _mediaUploads;
  FailedRecordingUploadHiveDbService get failedRecordingUploads =>
      _failedRecordingUploads;
  ExpenseCategoryHiveDbService get expenseCategories => _expenseCategories;
  PaymentTypeHiveDbService get paymentTypes => _paymentTypes;
  EventHiveDbService get events => _events;
  EventSubscriptionHiveDbService get eventSubscriptions => _eventSubscriptions;
  PaymentHiveDbService get payments => _payments;
  PrayerRequestHiveDbService get prayerRequests => _prayerRequests;
  MissionGroundSuggestionHiveDbService get missionGroundSuggestions =>
      _missionGroundSuggestions;
  RequisitionHiveDbService get requisitions => _requisitions;
  AllocationEntryHiveDbService get allocationEntries => _allocationEntries;
  SchoolHiveDbService get schools => _schools;

  // ----- Initialisation -----

  Future<void> initBoxes() async {
    await Hive.initFlutter();

    // Register generated adapters.
    Hive.registerAdapters();

    final appBoxName = PRFSuperAppConfig.instance!.values.hiveBox;
    final globalAuthBoxName =
        PRFSuperAppConfig.instance!.values.globalHiveAuthBox;

    final cipher = _buildCipher();

    await _runLegacyAdapterMigrationIfNeeded(
      appBoxName: appBoxName,
      globalAuthBoxName: globalAuthBoxName,
    );

    // Open auth/settings boxes.
    await _openBoxSafe(appBoxName, cipher: cipher);
    await _openBoxSafe(globalAuthBoxName, cipher: cipher);

    // Initialize auth/settings sub-services.
    _auth = AuthHiveService();
    _settings = SettingsHiveService();

    // Instantiate entity CRUD services.
    _announcements = AnnouncementHiveDbService();
    _classGroups = ClassGroupHiveDbService();
    _courses = CourseHiveDbService();
    _courseModules = CourseModuleHiveDbService();
    _lessonModules = LessonModuleHiveDbService();
    _studentEnquiries = StudentEnquiryHiveDbService();
    _studentEnquiryReplies = StudentEnquiryReplyHiveDbService();
    _faqs = FaqHiveDbService();
    _faqCategories = FaqCategoryHiveDbService();
    _debriefNotes = DebriefNoteHiveDbService();
    _missions = MissionHiveDbService();
    _missionQuestions = MissionQuestionHiveDbService();
    _missionSessions = MissionSessionHiveDbService();
    _missionSubscriptions = MissionSubscriptionHiveDbService();
    _subscriptions = SubscriptionHiveDbService();
    _memberMissions = MemberMissionHiveDbService();
    _prayerResponses = PrayerResponseHiveDbService();
    _souls = SoulHiveDbService();
    _mediaUploads = MediaUploadHiveDbService();
    _failedRecordingUploads = FailedRecordingUploadHiveDbService();
    _expenseCategories = ExpenseCategoryHiveDbService();
    _paymentTypes = PaymentTypeHiveDbService();
    _events = EventHiveDbService();
    _eventSubscriptions = EventSubscriptionHiveDbService();
    _payments = PaymentHiveDbService();
    _prayerRequests = PrayerRequestHiveDbService();
    _missionGroundSuggestions = MissionGroundSuggestionHiveDbService();
    _requisitions = RequisitionHiveDbService();
    _allocationEntries = AllocationEntryHiveDbService();
    _schools = SchoolHiveDbService();

    // Open all entity boxes with the shared cipher.
    final entityBoxNames = [
      _announcements.boxName,
      _classGroups.boxName,
      _courses.boxName,
      _courseModules.boxName,
      _lessonModules.boxName,
      _studentEnquiries.boxName,
      _studentEnquiryReplies.boxName,
      _faqs.boxName,
      _faqCategories.boxName,
      _debriefNotes.boxName,
      _missions.boxName,
      _missionQuestions.boxName,
      _missionSessions.boxName,
      _missionSubscriptions.boxName,
      _subscriptions.boxName,
      _memberMissions.boxName,
      _prayerResponses.boxName,
      _souls.boxName,
      _mediaUploads.boxName,
      _failedRecordingUploads.boxName,
      _expenseCategories.boxName,
      _paymentTypes.boxName,
      _events.boxName,
      _eventSubscriptions.boxName,
      _payments.boxName,
      _prayerRequests.boxName,
      _missionGroundSuggestions.boxName,
      _requisitions.boxName,
      _allocationEntries.boxName,
      _schools.boxName,
    ];

    for (final name in entityBoxNames) {
      await _openBoxSafe(name, cipher: cipher);
    }
  }

  HiveAesCipher? _buildCipher() {
    final key = PRFSuperAppConfig.instance!.values.hiveEncryptionKey;
    if (key.isEmpty) {
      return null;
    }

    try {
      final decodedKey = base64Decode(key);
      return HiveAesCipher(Uint8List.fromList(decodedKey));
    } catch (_) {
      // Fallback for plain-text keys: derive a stable 32-byte key.
    }

    final hashedKey = sha256.convert(utf8.encode(key)).bytes;
    return HiveAesCipher(Uint8List.fromList(hashedKey));
  }

  Future<Box<dynamic>> _openBoxSafe(
    String name, {
    HiveAesCipher? cipher,
  }) async {
    try {
      return await Hive.openBox<dynamic>(name, encryptionCipher: cipher);
    } catch (_) {
      await Hive.deleteBoxFromDisk(name);
      return Hive.openBox<dynamic>(name, encryptionCipher: cipher);
    }
  }

  Future<void> _runLegacyAdapterMigrationIfNeeded({
    required String appBoxName,
    required String globalAuthBoxName,
  }) async {
    final migrationBox = await _openBoxSafe(_migrationMetaBoxName);
    final hasMigrated =
        migrationBox.get(_binaryAdapterMigrationMarker) as bool? ?? false;
    if (hasMigrated) {
      await migrationBox.close();
      return;
    }

    // Legacy adapters used JSON-string payloads. Generated adapters use
    // binary fields, so reset once before opening app/global boxes.
    if (await Hive.boxExists(appBoxName)) {
      await Hive.deleteBoxFromDisk(appBoxName);
    }

    if (await Hive.boxExists(globalAuthBoxName)) {
      await Hive.deleteBoxFromDisk(globalAuthBoxName);
    }

    await migrationBox.put(_binaryAdapterMigrationMarker, true);
    await migrationBox.close();
  }

  // ----- Entity table management -----

  /// Wipes all entity boxes. Called on sign-out to clear user data.
  Future<void> clearAllTables() async {
    final services = <BaseHiveDbService<dynamic>>[
      _announcements,
      _classGroups,
      _courses,
      _courseModules,
      _lessonModules,
      _studentEnquiries,
      _studentEnquiryReplies,
      _faqs,
      _faqCategories,
      _debriefNotes,
      _missions,
      _missionQuestions,
      _missionSessions,
      _missionSubscriptions,
      _memberMissions,
      _prayerResponses,
      _souls,
      _mediaUploads,
      _expenseCategories,
      _paymentTypes,
      _events,
      _eventSubscriptions,
      _payments,
      _prayerRequests,
      _missionGroundSuggestions,
      _requisitions,
      _allocationEntries,
      _subscriptions,
      _schools
    ];
    for (final s in services) {
      await s.clearAll();
    }
    await _failedRecordingUploads.clearAll();
  }

  // ----- Convenience methods -----

  void clearPrefs() {
    _auth.clearAuthData();
  }

  void clearBox() {
    _auth.clear();
  }

  // Member-related convenience methods
  PRFMember? retrieveMember() {
    return _auth.retrieveProfile()?.member;
  }

  List<String> retrieveMemberGroupUlids() {
    return retrieveMember()!.groupMembers
            ?.map((groupMember) => groupMember.group!.ulid)
            .toList() ??
        [];
  }
}
