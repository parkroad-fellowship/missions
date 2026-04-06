import 'package:app/features/home/shared/cubit/announcement_resource_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AnnouncementsModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<AnnouncementService>(AnnouncementService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<AnnouncementResourceCubit>(
        create: (context) => AnnouncementResourceCubit(
          announcementService: getIt(),
          dbService: getIt<IsarService>().announcements,
        ),
      ),
    ];
  }
}
