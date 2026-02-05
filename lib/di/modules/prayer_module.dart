import 'package:app/features/home/prayer_requests/cubit/add_prayer_request_cubit.dart';
import 'package:app/features/home/prayer_requests/cubit/get_prayer_requests_cubit.dart';
import 'package:app/features/home/shared/cubit/get_prayer_prompts_cubit.dart';
import 'package:app/features/home/shared/cubit/save_prayer_response_cubit.dart';
import 'package:app/features/home/shared/cubit/upload_prayer_response_cubit.dart';
import 'package:app/services/api/prayer_prompt_service.dart';
import 'package:app/services/api/prayer_request_service.dart';
import 'package:app/services/api/prayer_response_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Prayer module for registering prayer-related services and cubits.
///
/// Includes:
/// - Prayer prompt services
/// - Prayer response services
/// - Prayer request services
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
          isarService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UploadPrayerResponseCubit>(
        create: (context) => UploadPrayerResponseCubit(
          isarService: getIt(),
          prayerResponseService: getIt(),
        ),
      ),
      BlocProvider<AddPrayerRequestCubit>(
        create: (context) => AddPrayerRequestCubit(
          prayerRequestService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetPrayerRequestsCubit>(
        create: (context) => GetPrayerRequestsCubit(
          prayerRequestService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
