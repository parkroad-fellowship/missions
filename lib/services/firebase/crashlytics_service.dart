/// Abstract interface for Firebase Crashlytics.
///
/// Provides crash reporting and error logging functionality.
abstract class CrashlyticsService {
  /// Record an error with optional stack trace and reason.
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Set a custom key-value pair for crash reports.
  Future<void> setCustomKey(String key, Object value);

  /// Set the user ID for crash reports.
  Future<void> setUserId(String userId);

  /// Log a message to the crash report.
  Future<void> log(String message);
}
