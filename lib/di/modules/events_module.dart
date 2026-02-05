import 'package:app/features/home/events/cubit/add_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/delete_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/get_event_media_cubit.dart';
import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/events/cubit/update_event_subscription_cubit.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Events module for registering event-related services and cubits.
///
/// Includes:
/// - Event services
/// - Event subscription services
class EventsModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<EventService>(EventService())
      ..registerSingleton<EventSubscriptionService>(EventSubscriptionService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<GetEventsCubit>(
        create: (context) => GetEventsCubit(eventService: getIt()),
      ),
      BlocProvider<GetMemberEventSubscriptionsCubit>(
        create: (context) => GetMemberEventSubscriptionsCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetEventMediaCubit>(
        create: (context) => GetEventMediaCubit(eventService: getIt()),
      ),
      BlocProvider<AddEventSubscriptionCubit>(
        create: (context) => AddEventSubscriptionCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UpdateEventSubscriptionCubit>(
        create: (context) => UpdateEventSubscriptionCubit(
          eventSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<DeleteEventSubscriptionCubit>(
        create: (context) => DeleteEventSubscriptionCubit(
          eventSubscriptionService: getIt(),
        ),
      ),
    ];
  }
}
