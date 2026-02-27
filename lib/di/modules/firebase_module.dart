import 'package:app/services/analytics/analytics_service.dart';
import 'package:app/services/analytics/posthog_analytics_service.dart';
import 'package:app/services/error_handler_service.dart';
import 'package:app/services/firebase/crashlytics_service.dart';
import 'package:app/services/firebase/crashlytics_service_impl.dart';
import 'package:app/services/firebase/firebase_analytics_service.dart';
import 'package:app/services/firebase/firebase_analytics_service_impl.dart';
import 'package:app/services/firebase_messaging_service.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/services/socket_service.dart';
import 'package:get_it/get_it.dart';

/// Firebase module for registering Firebase-related services.
///
/// Includes:
/// - Firebase authentication
/// - Firebase messaging
/// - Analytics (PostHog + Firebase)
/// - Crashlytics
/// - Error handling
/// - Notifications
/// - Socket connections
class FirebaseModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<FirebaseService>(FirebaseServiceImpl())
      ..registerSingleton<FirebaseMessagingService>(
        FirebaseMessagingServiceImpl(),
      )
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      ..registerSingleton<SocketService>(
        SocketServiceImpl(isarService: getIt()),
      )
      ..registerSingleton<AnalyticsService>(PostHogAnalyticsService())
      ..registerSingleton<FirebaseAnalyticsService>(
        FirebaseAnalyticsServiceImpl(),
      )
      ..registerSingleton<CrashlyticsService>(CrashlyticsServiceImpl())
      ..registerSingleton<ErrorHandlerService>(
        ErrorHandlerServiceImpl(
          analyticsService: getIt(),
          crashlyticsService: getIt(),
        ),
      );
  }
}
