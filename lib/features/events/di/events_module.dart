import 'package:app/features/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/events/cubit/event_resource_cubit.dart';
import 'package:app/features/events/cubit/event_subscription_resource_cubit.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned events registrations.
class EventsModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<EventService>(EventService())
      ..registerSingleton<EventSubscriptionService>(EventSubscriptionService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<EventResourceCubit>(
        create: (context) => EventResourceCubit(
          eventService: getIt<EventService>(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<EventMediaResourceCubit>(
        create: (context) =>
            EventMediaResourceCubit(eventService: getIt<EventService>()),
      ),
      BlocProvider<EventSubscriptionResourceCubit>(
        create: (context) => EventSubscriptionResourceCubit(
          eventSubscriptionService: getIt<EventSubscriptionService>(),
          hiveService: getIt<HiveService>(),
        ),
      ),
    ];
  }
}
