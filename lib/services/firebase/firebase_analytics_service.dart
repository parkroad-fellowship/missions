import 'package:firebase_analytics/firebase_analytics.dart';

/// Abstract interface for Firebase Analytics.
///
/// Provides standard Firebase Analytics functionality including
/// event logging, screen tracking, and user identification.
abstract class FirebaseAnalyticsService {
  /// Get the analytics observer for navigation tracking.
  FirebaseAnalyticsObserver get observer;

  /// Log a custom event with optional parameters.
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  /// Log a screen view event.
  Future<void> logScreenView({required String screenName});

  /// Log an exception event.
  Future<void> logException({
    required String description,
    bool fatal = false,
    Map<String, Object?>? parameters,
  });

  /// Set the user ID for analytics.
  Future<void> setUserId(String? userId);
}
