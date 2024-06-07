import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/auth_service.dart';
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
    ];
  }
}
