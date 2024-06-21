import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/features/home/missions/cubit/add_debrief_note_cubit.dart';
import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_past_member_missions_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<HiveService>(HiveServiceImpl())
      ..registerSingleton<AuthService>(AuthServiceImpl())
      ..registerSingleton<MissionService>(MissionServiceImpl())
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<SoulService>(SoulServiceImpl())
      ..registerSingleton<DebriefService>(DebriefServiceImpl())
      ..registerSingleton<LMSService>(LMSServiceImpl());
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<SignOutCubit>(
        create: (context) => SignOutCubit(
          hiveService: getIt(),
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
      BlocProvider<GetPastMemberMissionsCubit>(
        create: (context) => GetPastMemberMissionsCubit(
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
        ),
      ),
      BlocProvider<GetCourseModulesCubit>(
        create: (context) => GetCourseModulesCubit(
          lmsService: getIt(),
        ),
      ),
    ];
  }

  static void setupWebsocketConnection() {}
}
