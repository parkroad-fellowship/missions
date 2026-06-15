import 'package:app/features/home/account/cubit/change_profile_picture_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for account flows.
class AccountModule {
  static void register(GetIt getIt) {}

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<SignOutCubit>(
        create: (context) => SignOutCubit(
          hiveService: getIt(),
        ),
      ),
      BlocProvider<ChangeProfilePictureCubit>(
        create: (context) => ChangeProfilePictureCubit(
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
