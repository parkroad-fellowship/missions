import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/features/home/account/cubit/change_profile_picture_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/cubit/save_prayer_response_cubit.dart';
import 'package:app/features/home/cubit/upload_prayer_response_cubit.dart';
import 'package:app/features/home/events/cubit/add_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/delete_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/get_event_media_cubit.dart';
import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/events/cubit/update_event_subscription_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/features/home/giving/cubit/add_payment_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payments_cubit.dart';
import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/get_mission_ground_suggestions_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/update_mission_ground_suggestion_cubit.dart';
import 'package:app/features/home/missions/cubit/add_debrief_note_cubit.dart';
import 'package:app/features/home/missions/cubit/add_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/add_mission_question_cubit.dart';
import 'package:app/features/home/missions/cubit/add_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/add_token_cubit.dart';
import 'package:app/features/home/missions/cubit/delete_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/update_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/features/home/prayer_requests/cubit/add_prayer_request_cubit.dart';
import 'package:app/features/home/prayer_requests/cubit/get_prayer_requests_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_student_enquiry_replies_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:app/services/api/class_group_service.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:app/services/api/expense_categories_service.dart';
import 'package:app/services/api/expense_service.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/api/mission_expenses_service.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/api/mission_ground_suggestion_service.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/api/payment_type_service.dart';
import 'package:app/services/api/prayer_prompt_service.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/api/prayer_response_service.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/services/local_auth_service.dart';
import 'package:app/utils/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

final GetIt getIt = GetIt.instance;
late Isar prfDBInstance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<PRFSuperAppRouter>(PRFSuperAppRouter())
      ..registerSingleton<HiveService>(HiveService())
      ..registerSingleton<LocalDBService>(LocalDBServiceImpl())
      ..registerSingleton<LocalAuthService>(LocalAuthService())
      ..registerSingleton<FirebaseService>(FirebaseServiceImpl())
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
      ..registerSingleton<MissionExpensesService>(
        MissionExpensesService(),
      )
      ..registerSingleton<ExpenseService>(ExpenseService())
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
      ..registerSingleton<LessonMemberService>(
        LessonMemberService(),
      )
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<SocketService>(
        SocketServiceImpl(localDBService: getIt()),
      )
      ..registerSingleton<MediaService>(MediaServiceImpl())
      ..registerSingleton<AnalyticsService>(AnalyticsServiceImpl());
  }

  static Future<void> setupDatabase() async {
    await getIt<HiveService>().initBoxes();

    prfDBInstance = await getIt<LocalDBService>().initDatabase();
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
          socketService: getIt(),
          analyticsService: getIt(),
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
            SignOutCubit(hiveService: getIt(), localDBService: getIt()),
      ),
      BlocProvider<GetMissionsCubit>(
        create: (context) => GetMissionsCubit(
          missionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetSubscribersCubit>(
        create: (context) => GetSubscribersCubit(
          missionSubscriptionService: getIt(),
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<SubscribeCubit>(
        create: (context) => SubscribeCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
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
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetSoulsCubit>(
        create: (context) =>
            GetSoulsCubit(soulService: getIt(), localDBService: getIt()),
      ),
      BlocProvider<GetClassGroupsCubit>(
        create: (context) => GetClassGroupsCubit(
          classGroupService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<AddSoulCubit>(
        create: (context) =>
            AddSoulCubit(soulService: getIt(), localDBService: getIt()),
      ),
      BlocProvider<GetDebriefNotesCubit>(
        create: (context) => GetDebriefNotesCubit(
          debriefNoteService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<AddDebriefNoteCubit>(
        create: (context) => AddDebriefNoteCubit(
          debriefNoteService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetCoursesCubit>(
        create: (context) => GetCoursesCubit(
          courseService: getIt(),
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetCourseModulesCubit>(
        create: (context) => GetCourseModulesCubit(
          courseModuleService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<FinishLessonCubit>(
        create: (context) => FinishLessonCubit(
          lessonMemberService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetFaqsCubit>(
        create: (context) =>
            GetFaqsCubit(missionFaqService: getIt(), localDBService: getIt()),
      ),
      BlocProvider<GetFaqCategoriesCubit>(
        create: (context) => GetFaqCategoriesCubit(
          missionFaqCategoryService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiriesCubit>(
        create: (context) => GetEnquiriesCubit(
          studentEnquiryService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<CreateEnquiryReplyCubit>(
        create: (context) => CreateEnquiryReplyCubit(
          studentEnquiryService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiryRepliesCubit>(
        create: (context) => GetEnquiryRepliesCubit(
          studentEnquiryService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetAnnouncementsCubit>(
        create: (context) => GetAnnouncementsCubit(
          announcementService: getIt(),
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMissionQuestionsCubit>(
        create: (context) => GetMissionQuestionsCubit(
          missionQuestionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<AddMissionQuestionCubit>(
        create: (context) => AddMissionQuestionCubit(
          missionQuestionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetPrayerPromptsCubit>(
        create: (context) => GetPrayerPromptsCubit(
          prayerPromptService: getIt(),
          notificationService: getIt(),
        ),
      ),
      BlocProvider<SavePrayerResponseCubit>(
        create: (context) => SavePrayerResponseCubit(
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UploadPrayerResponseCubit>(
        create: (context) => UploadPrayerResponseCubit(
          localDBService: getIt(),
          prayerResponseService: getIt(),
        ),
      ),
      BlocProvider<GetExpenseCategoriesCubit>(
        create: (context) => GetExpenseCategoriesCubit(
          expenseCategoriesService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMissionExpenseCubit>(
        create: (context) => GetMissionExpenseCubit(
          missionExpensesService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<AddExpenseCubit>(
        create: (context) =>
            AddExpenseCubit(expenseService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<AddTokenCubit>(
        create: (context) => AddTokenCubit(missionExpensesService: getIt()),
      ),
      BlocProvider<SelectMediaCubit>(
        create: (context) => SelectMediaCubit(
          mediaService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<UploadMediaCubit>(
        create: (context) => UploadMediaCubit(
          mediaService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetMissionMediaCubit>(
        create: (context) => GetMissionMediaCubit(missionService: getIt()),
      ),
      BlocProvider<GetMissionSessionsCubit>(
        create: (context) => GetMissionSessionsCubit(
          missionSessionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<AddMissionSessionCubit>(
        create: (context) => AddMissionSessionCubit(
          missionSessionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<UpdateMissionSessionCubit>(
        create: (context) => UpdateMissionSessionCubit(
          missionSessionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<DeleteMissionSessionCubit>(
        create: (context) => DeleteMissionSessionCubit(
          missionSessionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetMissionGroundSuggestionsCubit>(
        create: (context) => GetMissionGroundSuggestionsCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<AddMissionGroundSuggestionCubit>(
        create: (context) => AddMissionGroundSuggestionCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UpdateMissionGroundSuggestionCubit>(
        create: (context) => UpdateMissionGroundSuggestionCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetPaymentsCubit>(
        create: (context) =>
            GetPaymentsCubit(paymentService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<GetPaymentTypesCubit>(
        create: (context) => GetPaymentTypesCubit(
          paymentTypeService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<AddPaymentCubit>(
        create: (context) =>
            AddPaymentCubit(paymentService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<GetMissionSessionCubit>(
        create: (context) => GetMissionSessionCubit(
          missionSessionService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<DownloadFileCubit>(
        create: (context) => DownloadFileCubit(mediaService: getIt()),
      ),
      BlocProvider<GetEventsCubit>(
        create: (context) => GetEventsCubit(eventService: getIt()),
      ),
      BlocProvider<GetMemberEventSubscriptionsCubit>(
        create: (context) => GetMemberEventSubscriptionsCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetEventMediaCubit>(
        create: (context) => GetEventMediaCubit(eventService: getIt()),
      ),
      BlocProvider<AddEventSubscriptionCubit>(
        create: (context) => AddEventSubscriptionCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UpdateEventSubscriptionCubit>(
        create: (context) => UpdateEventSubscriptionCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<DeleteEventSubscriptionCubit>(
        create: (context) =>
            DeleteEventSubscriptionCubit(eventSubscriptionService: getIt()),
      ),
      BlocProvider<ChangeProfilePictureCubit>(
        create: (context) => ChangeProfilePictureCubit(
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      ),

      BlocProvider<AddPrayerRequestCubit>(
        create: (context) => AddPrayerRequestCubit(
          prayerRequestService: getIt(),
          hiveService: getIt(),
        ),
      ),

      BlocProvider<GetPrayerRequestsCubit>(
        create: (context) => GetPrayerRequestsCubit(
          prayerRequestService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
