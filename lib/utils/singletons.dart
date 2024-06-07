import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/my_missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<HiveService>(HiveServiceImpl())
      ..registerSingleton<AuthService>(AuthServiceImpl())
      ..registerSingleton<MissionService>(MissionServiceImpl());
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
      BlocProvider<GetMemberMissionSubscriptionsCubit>(
        create: (context) => GetMemberMissionSubscriptionsCubit(
          missionService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
