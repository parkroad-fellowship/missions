import 'package:app/features/auth/cubit/login_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Singletons {
  static void setup() {
    getIt
      ..registerSingleton<HiveService>(HiveServiceImplementation())
      ..registerSingleton<AuthService>(AuthServiceImpl());
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
