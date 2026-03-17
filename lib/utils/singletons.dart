import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/features/home/account/cubit/change_profile_picture_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/features/home/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/home/events/cubit/event_resource_cubit.dart';
import 'package:app/features/home/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_type_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/module_resource_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/audio_recording_cubit.dart';
import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/expense_category_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/expenses/cubit/delete_receipt_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/save_prayer_response_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_reply_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<PRFSuperAppRouter>(PRFSuperAppRouter())
      ..registerSingleton<HiveService>(HiveService())
      ..registerSingleton<IsarService>(IsarService())
      ..registerSingleton<LocalAuthService>(LocalAuthService())
      ..registerSingleton<FirebaseService>(FirebaseServiceImpl())
      ..registerSingleton<FirebaseMessagingService>(
        FirebaseMessagingServiceImpl(),
      )
      ..registerSingleton<AuthService>(AuthService())
      ..registerSingleton<MissionService>(MissionService())
      ..registerSingleton<MissionSubscriptionService>(
        MissionSubscriptionService(),
      )
      ..registerSingleton<MissionSessionService>(
        MissionSessionService(),
      )
      ..registerSingleton<AnnouncementService>(
        AnnouncementService(),
      )
      ..registerSingleton<PrayerPromptService>(
        PrayerPromptService(),
      )
      ..registerSingleton<PrayerResponseService>(
        PrayerResponseService(),
      )
      ..registerSingleton<ExpenseCategoriesService>(
        ExpenseCategoriesService(),
      )
      ..registerSingleton<MissionQuestionService>(
        MissionQuestionService(),
      )
      ..registerSingleton<DebriefNoteService>(
        DebriefNoteService(),
      )
      ..registerSingleton<MissionGroundSuggestionService>(
        MissionGroundSuggestionService(),
      )
      ..registerSingleton<PaymentService>(PaymentService())
      ..registerSingleton<PaymentTypeService>(PaymentTypeService())
      ..registerSingleton<PrayerRequestService>(
        PrayerRequestService(),
      )
      ..registerSingleton<ClassGroupService>(ClassGroupService())
      ..registerSingleton<SoulService>(SoulService())
      ..registerSingleton<EventService>(EventService())
      ..registerSingleton<EventSubscriptionService>(
        EventSubscriptionService(),
      )
      ..registerSingleton<MissionFaqService>(MissionFaqService())
      ..registerSingleton<MissionFaqCategoryService>(
        MissionFaqCategoryService(),
      )
      ..registerSingleton<StudentEnquiryService>(
        StudentEnquiryService(),
      )
      ..registerSingleton<StudentEnquiryReplyService>(
        StudentEnquiryReplyService(),
      )
      ..registerSingleton<CourseService>(CourseService())
      ..registerSingleton<CourseModuleService>(
        CourseModuleService(),
      )
      ..registerSingleton<LessonModuleService>(LessonModuleService())
      ..registerSingleton<LessonMemberService>(
        LessonMemberService(),
      )
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<SocketService>(
        SocketServiceImpl(isarService: getIt()),
      )
      ..registerSingleton<MediaService>(MediaServiceImpl())
      ..registerSingleton<AnalyticsService>(PostHogAnalyticsService())
      ..registerSingleton<AudioRecordingService>(AudioRecordingService())
      ..registerSingleton<FailedRecordingUploadService>(
        FailedRecordingUploadService(
          isarService: getIt(),
          mediaService: getIt(),
        ),
      )
      ..registerSingleton<MemberService>(MemberService())
      ..registerSingleton<AccountingEventService>(AccountingEventService())
      ..registerSingleton<AllocationEntryService>(AllocationEntryService())
      ..registerSingleton<RefundService>(RefundService());
  }

  static Future<void> setupDatabases() async {
    await getIt<HiveService>().initBoxes();
    await getIt<IsarService>().initDatabase();
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[
      // --- Auth cubits (keep as-is) ---
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
          socketService: getIt(),
          analyticsService: getIt(),
          firebaseMessagingService: getIt(),
        ),
      ),
      BlocProvider<GoogleSignInCubit>(
        create: (context) => GoogleSignInCubit(firebaseService: getIt()),
      ),
      BlocProvider<SocialLoginCubit>(
        create: (context) =>
            SocialLoginCubit(authService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<SignOutCubit>(
        create: (context) =>
            SignOutCubit(hiveService: getIt(), isarService: getIt()),
      ),

      // --- ResourceCubit replacements: Missions ---
      BlocProvider<MissionResourceCubit>(
        create: (context) => MissionResourceCubit(missionService: getIt()),
      ),
      BlocProvider<MissionSubscriptionResourceCubit>(
        create: (context) => MissionSubscriptionResourceCubit(
          missionSubscriptionService: getIt(),
        ),
      ),
      BlocProvider<ClassGroupResourceCubit>(
        create: (context) => ClassGroupResourceCubit(
          classGroupService: getIt(),
        ),
      ),
      BlocProvider<SoulResourceCubit>(
        create: (context) => SoulResourceCubit(soulService: getIt()),
      ),
      BlocProvider<DebriefNoteResourceCubit>(
        create: (context) => DebriefNoteResourceCubit(
          debriefNoteService: getIt(),
        ),
      ),
      BlocProvider<MissionQuestionResourceCubit>(
        create: (context) => MissionQuestionResourceCubit(
          missionQuestionService: getIt(),
        ),
      ),
      BlocProvider<MissionSessionResourceCubit>(
        create: (context) => MissionSessionResourceCubit(
          missionSessionService: getIt(),
        ),
      ),
      BlocProvider<MissionMediaResourceCubit>(
        create: (context) => MissionMediaResourceCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<GroundSuggestionResourceCubit>(
        create: (context) => GroundSuggestionResourceCubit(
          missionGroundSuggestionService: getIt(),
        ),
      ),

      // --- Keep-as-is: Mission subscription/withdraw ---
      BlocProvider<SubscribeCubit>(
        create: (context) => SubscribeCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<WithdrawCubit>(
        create: (context) => WithdrawCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMemberMissionSubscriptionsCubit>(
        create: (context) => GetMemberMissionSubscriptionsCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Expenses ---
      BlocProvider<ExpenseCategoryResourceCubit>(
        create: (context) => ExpenseCategoryResourceCubit(
          expenseCategoriesService: getIt(),
        ),
      ),
      BlocProvider<AllocationEntryResourceCubit>(
        create: (context) => AllocationEntryResourceCubit(
          allocationEntryService: getIt(),
          mediaService: getIt(),
          refundService: getIt(),
        ),
      ),
      // Keep-as-is: DeleteReceiptCubit
      BlocProvider<DeleteReceiptCubit>(
        create: (context) => DeleteReceiptCubit(
          allocationEntryService: getIt(),
        ),
      ),

      // --- Keep-as-is: Media cubits ---
      BlocProvider<SelectMediaCubit>(
        create: (context) => SelectMediaCubit(
          mediaService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<UploadMediaCubit>(
        create: (context) => UploadMediaCubit(
          mediaService: getIt(),
          isarService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: LMS ---
      BlocProvider<CourseResourceCubit>(
        create: (context) => CourseResourceCubit(courseService: getIt()),
      ),
      BlocProvider<ModuleResourceCubit>(
        create: (context) => ModuleResourceCubit(
          courseModuleService: getIt(),
        ),
      ),
      BlocProvider<LessonResourceCubit>(
        create: (context) => LessonResourceCubit(
          lessonModuleService: getIt(),
          lessonMemberService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: FAQs & Enquiries ---
      BlocProvider<FaqResourceCubit>(
        create: (context) => FaqResourceCubit(missionFaqService: getIt()),
      ),
      BlocProvider<FaqCategoryResourceCubit>(
        create: (context) => FaqCategoryResourceCubit(
          missionFaqCategoryService: getIt(),
        ),
      ),
      BlocProvider<EnquiryResourceCubit>(
        create: (context) => EnquiryResourceCubit(
          studentEnquiryService: getIt(),
        ),
      ),
      BlocProvider<EnquiryReplyResourceCubit>(
        create: (context) => EnquiryReplyResourceCubit(
          studentEnquiryReplyService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Announcements ---
      BlocProvider<AnnouncementResourceCubit>(
        create: (context) => AnnouncementResourceCubit(
          announcementService: getIt(),
        ),
      ),

      // --- Keep-as-is: Prayer ---
      BlocProvider<GetPrayerPromptsCubit>(
        create: (context) => GetPrayerPromptsCubit(
          prayerPromptService: getIt(),
          notificationService: getIt(),
        ),
      ),
      BlocProvider<SavePrayerResponseCubit>(
        create: (context) => SavePrayerResponseCubit(
          isarService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UploadPrayerResponseCubit>(
        create: (context) => UploadPrayerResponseCubit(
          isarService: getIt(),
          prayerResponseService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Prayer Requests ---
      BlocProvider<PrayerRequestResourceCubit>(
        create: (context) => PrayerRequestResourceCubit(
          prayerRequestService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Payments ---
      BlocProvider<PaymentResourceCubit>(
        create: (context) => PaymentResourceCubit(paymentService: getIt()),
      ),
      BlocProvider<PaymentTypeResourceCubit>(
        create: (context) => PaymentTypeResourceCubit(
          paymentTypeService: getIt(),
        ),
      ),

      // --- Keep-as-is: Download/Audio ---
      BlocProvider<DownloadFileCubit>(
        create: (context) => DownloadFileCubit(mediaService: getIt()),
      ),
      BlocProvider<AudioRecordingCubit>(
        create: (context) => AudioRecordingCubit(
          recordingService: getIt(),
        ),
      ),
      BlocProvider<RecordingUploadCubit>(
        create: (context) => RecordingUploadCubit(
          mediaService: getIt(),
          failedUploadService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Events ---
      BlocProvider<EventResourceCubit>(
        create: (context) => EventResourceCubit(eventService: getIt()),
      ),
      BlocProvider<EventMediaResourceCubit>(
        create: (context) => EventMediaResourceCubit(eventService: getIt()),
      ),
      BlocProvider<EventSubscriptionResourceCubit>(
        create: (context) => EventSubscriptionResourceCubit(
          eventSubscriptionService: getIt(),
        ),
      ),

      // --- Keep-as-is: Account ---
      BlocProvider<ChangeProfilePictureCubit>(
        create: (context) => ChangeProfilePictureCubit(
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      ),

      // --- ResourceCubit replacements: Members ---
      BlocProvider<MemberEngagementResourceCubit>(
        create: (context) => MemberEngagementResourceCubit(
          memberService: getIt(),
        ),
      ),
    ];
  }
}
