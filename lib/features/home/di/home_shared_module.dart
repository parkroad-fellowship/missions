import 'package:app/shared/theme/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for shared home-level cubits.
class HomeSharedModule {
  static void register(GetIt getIt) {}

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<ThemeCubit>(
        create: (context) => ThemeCubit(hiveService: getIt()),
      ),
    ];
  }
}
