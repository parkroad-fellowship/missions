import 'package:app/features/auth/cubit/register_student_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/features/home/missions/cubit/add_debrief_note_cubit.dart';
import 'package:app/features/home/missions/cubit/add_mission_question_cubit.dart';
import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_student_enquiry_replies_cubit.dart';
import 'package:app/features/student_home/enquiries/cubit/create_enquiry_cubit.dart';
import 'package:app/features/student_home/enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/student_home/enquiries/cubit/get_student_enquiries_cubit.dart';
import 'package:app/features/student_home/enquiries/cubit/get_student_enquiry_replies_cubit.dart';
import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

final getIt = GetIt.instance;
late Isar prfDBInstance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<HiveService>(HiveServiceImpl())
      ..registerSingleton<LocalDBService>(LocalDBServiceImpl())
      ..registerSingleton<AuthService>(AuthServiceImpl())
      ..registerSingleton<MissionService>(MissionServiceImpl())
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<SoulService>(SoulServiceImpl())
      ..registerSingleton<DebriefService>(DebriefServiceImpl())
      ..registerSingleton<LMSService>(LMSServiceImpl())
      ..registerSingleton<SocketService>(
        SocketServiceImpl(localDBService: getIt()),
      )
      ..registerSingleton<StudentService>(StudentServiceImpl());
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
        ),
      ),
      BlocProvider<RegisterStudentCubit>(
        create: (context) => RegisterStudentCubit(
          authService: getIt(),
        ),
      ),
      BlocProvider<SignOutCubit>(
        create: (context) => SignOutCubit(
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetMissionsCubit>(
        create: (context) => GetMissionsCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<GetSubscribersCubit>(
        create: (context) => GetSubscribersCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<SubscribeCubit>(
        create: (context) => SubscribeCubit(
          missionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<WithdrawCubit>(
        create: (context) => WithdrawCubit(
          missionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMemberMissionSubscriptionsCubit>(
        create: (context) => GetMemberMissionSubscriptionsCubit(
          missionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetSoulsCubit>(
        create: (context) => GetSoulsCubit(
          soulService: getIt(),
        ),
      ),
      BlocProvider<GetClassGroupsCubit>(
        create: (context) => GetClassGroupsCubit(
          soulService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<AddSoulCubit>(
        create: (context) => AddSoulCubit(
          soulService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetDebriefNotesCubit>(
        create: (context) => GetDebriefNotesCubit(
          debriefService: getIt(),
        ),
      ),
      BlocProvider<AddDebriefNoteCubit>(
        create: (context) => AddDebriefNoteCubit(
          debriefService: getIt(),
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
        create: (context) => FinishLessonCubit(
          lmsService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetFaqsCubit>(
        create: (context) => GetFaqsCubit(
          studentService: getIt(),
        ),
      ),
      BlocProvider<GetStudentEnquiriesCubit>(
        create: (context) => GetStudentEnquiriesCubit(
          studentService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<GetStudentEnquiryRepliesCubit>(
        create: (context) => GetStudentEnquiryRepliesCubit(
          studentService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<CreateEnquiryCubit>(
        create: (context) => CreateEnquiryCubit(
          studentService: getIt(),
          hiveService: getIt(),
          localDBService: getIt(),
        ),
      ),
      BlocProvider<CreateStudentEnquiryReplyCubit>(
        create: (context) => CreateStudentEnquiryReplyCubit(
          studentService: getIt(),
          hiveService: getIt(),
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
          missionService: getIt(),
          localDBService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMissionQuestionsCubit>(
        create: (context) => GetMissionQuestionsCubit(
          debriefService: getIt(),
        ),
      ),
      BlocProvider<AddMissionQuestionCubit>(
        create: (context) => AddMissionQuestionCubit(
          debriefService: getIt(),
        ),
      ),
    ];
  }
}
