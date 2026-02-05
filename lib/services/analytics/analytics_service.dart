import 'package:app/models/remote/common/auth.dart';

/// Abstract interface for analytics services.
///
/// Implementations can use PostHog, Firebase Analytics, or any other
/// analytics provider.
abstract class AnalyticsService {
  /// Initialize the analytics service.
  Future<void> init();

  /// Identify a user for tracking purposes.
  Future<void> identifyUser({required PRFUser user});

  /// Capture a custom event with optional properties.
  Future<void> captureEvent(String eventName, [Map<String, Object>? props]);
}
