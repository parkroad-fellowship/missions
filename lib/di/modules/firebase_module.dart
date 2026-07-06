import 'package:app/services/analytics/_analytics_service.dart';
import 'package:app/services/analytics/unified_analytics_service.dart';
import 'package:app/services/errors/_error_reporting_service.dart';
import 'package:app/services/errors/unified_error_reporting_service.dart';
import 'package:app/services/firebase/firebase_messaging_service.dart';
import 'package:app/services/firebase/firebase_service.dart';
import 'package:app/services/notification_service.dart';
// import 'package:app/services/socket_service.dart';
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
      ..registerSingleton<PRFFirebaseService>(FirebaseServiceImpl())
      ..registerSingleton<FirebaseMessagingService>(
        FirebaseMessagingServiceImpl(),
      )
      ..registerSingleton<NotificationService>(NotificationServiceImpl())
      // ..registerSingleton<SocketService>(
      //   SocketServiceImpl(hiveService: getIt()),
      // )
      ..registerSingleton<AnalyticsService>(UnifiedAnalyticsService())
      ..registerSingleton<ErrorReportingService>(
        UnifiedErrorReportingService(
          analyticsService: getIt<AnalyticsService>(),
        ),
      );
  }
}
