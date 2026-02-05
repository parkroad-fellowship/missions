import 'package:app/di/modules/announcements_module.dart';
import 'package:app/di/modules/auth_module.dart';
import 'package:app/di/modules/core_module.dart';
import 'package:app/di/modules/enquiries_module.dart';
import 'package:app/di/modules/events_module.dart';
import 'package:app/di/modules/expenses_module.dart';
import 'package:app/di/modules/firebase_module.dart';
import 'package:app/di/modules/lms_module.dart';
import 'package:app/di/modules/media_module.dart';
import 'package:app/di/modules/members_module.dart';
import 'package:app/di/modules/missions_module.dart';
import 'package:app/di/modules/payments_module.dart';
import 'package:app/di/modules/prayer_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Global GetIt instance for dependency injection.
final GetIt getIt = GetIt.instance;

/// Main dependency injection container that orchestrates all modules.
///
/// Usage:
/// ```dart
/// // In main.dart or bootstrap.dart
/// DIContainer.setup();
/// await DIContainer.initializeDatabases();
///
/// // In your app widget
/// MultiBlocProvider(
///   providers: DIContainer.registerCubits(),
///   child: MyApp(),
/// )
/// ```
class DIContainer {
  /// Register all services across all modules.
  static void setup() {
    // Core infrastructure (must be first)
    CoreModule.register(getIt);

    // Firebase services (depends on core)
    FirebaseModule.register(getIt);

    // Media services (depends on core)
    MediaModule.register(getIt);

    // Domain-specific modules (alphabetical)
    AnnouncementsModule.register(getIt);
    AuthModule.register(getIt);
    EnquiriesModule.register(getIt);
    EventsModule.register(getIt);
    ExpensesModule.register(getIt);
    LmsModule.register(getIt);
    MembersModule.register(getIt);
    MissionsModule.register(getIt);
    PaymentsModule.register(getIt);
    PrayerModule.register(getIt);
  }

  /// Initialize databases (Hive and Isar).
  ///
  /// Must be called after [setup] and before using any database services.
  static Future<void> initializeDatabases() async {
    await CoreModule.initializeDatabases(getIt);
  }

  /// Register all BLoC providers for the application.
  ///
  /// Returns a list of [BlocProvider] instances that should be wrapped
  /// around the application widget tree.
  static List<BlocProvider> registerCubits() {
    return [
      // Core cubits (must be first - theme is needed by MaterialApp)
      ...CoreModule.registerCubits(getIt),
      // Domain-specific cubits
      ...AuthModule.registerCubits(getIt),
      ...MissionsModule.registerCubits(getIt),
      ...LmsModule.registerCubits(getIt),
      ...EnquiriesModule.registerCubits(getIt),
      ...AnnouncementsModule.registerCubits(getIt),
      ...PrayerModule.registerCubits(getIt),
      ...ExpensesModule.registerCubits(getIt),
      ...PaymentsModule.registerCubits(getIt),
      ...EventsModule.registerCubits(getIt),
      ...MembersModule.registerCubits(getIt),
    ];
  }
}
