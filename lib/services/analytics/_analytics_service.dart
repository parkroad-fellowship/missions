import 'package:app/models/remote/common/auth.dart';
import 'package:flutter/widgets.dart';

/// Abstract interface for analytics services.
///
/// Implementations can use PostHog, Firebase Analytics, or any other
/// analytics provider.
abstract class AnalyticsService {
  /// Navigator observers used for automatic screen tracking.
  List<NavigatorObserver> get navigatorObservers;

  /// Initialize the analytics service.
  Future<void> init();

  /// Identify a user for tracking purposes.
  Future<void> identifyUser({required PRFUser user});

  /// Set the user ID for analytics providers.
  Future<void> setUserId(String? userId);

  /// Log a custom event with optional parameters.
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  /// Capture a custom event with optional properties.
  ///
  /// Kept for backward compatibility. Prefer [logEvent] for new code.
  Future<void> captureEvent(String eventName, [Map<String, Object>? props]);

  /// Log a screen view event.
  Future<void> logScreenView({required String screenName});

  /// Log an exception event.
  Future<void> logException({
    required String description,
    bool fatal = false,
    Map<String, Object?>? parameters,
  });
}
