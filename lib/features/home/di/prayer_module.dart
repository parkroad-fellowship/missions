import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/save_prayer_response_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/services/api/prayer_prompt_service.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/api/prayer_response_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for prayer flows.
class PrayerModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<PrayerPromptService>(PrayerPromptService())
      ..registerSingleton<PrayerResponseService>(PrayerResponseService())
      ..registerSingleton<PrayerRequestService>(PrayerRequestService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<GetPrayerPromptsCubit>(
        create: (context) => GetPrayerPromptsCubit(
          prayerPromptService: getIt(),
          notificationService: getIt(),
        ),
      ),
      BlocProvider<SavePrayerResponseCubit>(
        create: (context) => SavePrayerResponseCubit(
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UploadPrayerResponseCubit>(
        create: (context) => UploadPrayerResponseCubit(
          hiveService: getIt(),
          prayerResponseService: getIt(),
        ),
      ),
      BlocProvider<PrayerRequestResourceCubit>(
        create: (context) => PrayerRequestResourceCubit(
          prayerRequestService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
    ];
  }
}
