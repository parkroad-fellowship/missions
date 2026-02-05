import 'package:app/features/home/shared/cubit/get_announcements_cubit.dart';
import 'package:app/services/api/announcement_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AnnouncementsModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<AnnouncementService>(AnnouncementService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<GetAnnouncementsCubit>(
        create: (context) => GetAnnouncementsCubit(
          announcementService: getIt(),
          isarService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
