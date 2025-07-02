import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/register_student_cubit.dart';
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
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_payment.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/models/remote/prf_prayer_request.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/_base_api_service.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/announcement_service.dart';
import 'package:app/services/class_group_service.dart';
import 'package:app/services/debrief_note_service.dart';
import 'package:app/services/event_service.dart';
import 'package:app/services/event_subscription_service.dart';
import 'package:app/services/expense_categories_service.dart';
import 'package:app/services/expense_service.dart';
import 'package:app/services/mission_expenses_service.dart';
import 'package:app/services/mission_ground_suggestion_service.dart';
import 'package:app/services/mission_question_service.dart';
import 'package:app/services/mission_subscription_service.dart';
import 'package:app/services/mission_service.dart';
import 'package:app/services/payment_service.dart';
import 'package:app/services/payment_type_service.dart';
import 'package:app/services/prayer_prompt_service.dart';
import 'package:app/services/prayer_request_service.dart';
import 'package:app/services/prayer_response_service.dart';
import 'package:app/utils/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

final GetIt getIt = GetIt.instance;
late Isar prfDBInstance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<PRFSuperAppRouter>(PRFSuperAppRouter())
      ..registerSingleton<HiveService>(HiveServiceImpl())
      ..registerSingleton<LocalDBService>(LocalDBServiceImpl())
      ..registerSingleton<AuthService>(AuthServiceImpl())
      // V2
      ..registerSingleton<BaseAPIService<PRFMission>>(MissionService())
      ..registerSingleton<BaseAPIService<PRFMissionSubscription>>(
        MissionSubscriptionService(),
      )
      ..registerSingleton<BaseAPIService<PRFAnnouncement>>(
        AnnouncementService(),
      )
      ..registerSingleton<BaseAPIService<PRFPrayerPrompt>>(
        PrayerPromptService(),
      )
      ..registerSingleton<BaseAPIService<PRFPrayerResponse>>(
        PrayerResponseService(),
      )
      ..registerSingleton<BaseAPIService<PRFExpenseCategory>>(
        ExpenseCategoriesService(),
      )
      ..registerSingleton<BaseAPIService<PRFMissionExpense>>(
        MissionExpensesService(),
      )
      ..registerSingleton<BaseAPIService<PRFExpense>>(ExpenseService())
      ..registerSingleton<BaseAPIService<PRFMissionQuestion>>(MissionQuestionService())
      ..registerSingleton<BaseAPIService<PRFDebriefNote>>(
        DebriefNoteService(),
      )
      ..registerSingleton<BaseAPIService<PRFMissionGroundSuggestion>>(MissionGroundSuggestionService())
      ..registerSingleton<BaseAPIService<PRFPayment>>(PaymentService())
      ..registerSingleton<BaseAPIService<PRFPaymentType>>(PaymentTypeService())
      ..registerSingleton<BaseAPIService<PRFPrayerRequest>>(PrayerRequestService())
      ..registerSingleton<BaseAPIService<PRFClassGroup>>(ClassGroupService())
      ..registerSingleton<BaseAPIService<PRFSoul>>(SoulService())
      ..registerSingleton<BaseAPIService<PRFEvent>>(EventService())
      ..registerSingleton<BaseAPIService<PRFEventSubscription>>(EventSubscriptionService())
      
      // End V2
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<LMSService>(LMSServiceImpl())
      ..registerSingleton<SocketService>(
        SocketServiceImpl(localDBService: getIt()),
      )
      ..registerSingleton<StudentService>(StudentServiceImpl())
      ..registerSingleton<MediaService>(MediaServiceImpl())
      ..registerSingleton<AnalyticsService>(AnalyticsServiceImpl());
  }

  static Future<void> setupDatabase() async {
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
        create: (context) => GoogleSignInCubit(authService: getIt()),
      ),
      BlocProvider<SocialLoginCubit>(
        create: (context) =>
            SocialLoginCubit(authService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<RegisterStudentCubit>(
        create: (context) => RegisterStudentCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
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
          lmsService: getIt(),
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetCourseModulesCubit>(
        create: (context) => GetCourseModulesCubit(
          lmsService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<FinishLessonCubit>(
        create: (context) =>
            FinishLessonCubit(lmsService: getIt(), hiveService: getIt()),
      ),
      BlocProvider<GetFaqsCubit>(
        create: (context) =>
            GetFaqsCubit(studentService: getIt(), localDBService: getIt()),
      ),
      BlocProvider<GetFaqCategoriesCubit>(
        create: (context) => GetFaqCategoriesCubit(
          studentService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiriesCubit>(
        create: (context) => GetEnquiriesCubit(
          studentService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<CreateEnquiryReplyCubit>(
        create: (context) => CreateEnquiryReplyCubit(
          studentService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiryRepliesCubit>(
        create: (context) => GetEnquiryRepliesCubit(
          studentService: getIt(),
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
