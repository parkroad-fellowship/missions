import 'package:app/models/remote/common/failure.dart';
import 'package:flutter/foundation.dart';

/// Abstract interface for reporting runtime errors across all enabled platforms.
///
/// Implementations can use Crashlytics, Sentry, or any other provider.
abstract class ErrorReportingService {
  /// Report a normalized failure to all configured platforms.
  Future<void> reportFailure(
    Failure failure, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  });

  /// Record an error with optional reason and severity.
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Record a Flutter framework fatal error.
  Future<void> recordFlutterFatalError(FlutterErrorDetails errorDetails);

  /// Set a custom key-value pair for reports.
  Future<void> setCustomKey(String key, Object value);

  /// Set the user ID for reports.
  Future<void> setUserId(String userId);

  /// Log a diagnostic message to the provider.
  Future<void> log(String message);
}
