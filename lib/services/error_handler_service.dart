import 'package:app/enums/error_severity.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/analytics/analytics_service.dart';
import 'package:app/services/firebase/crashlytics_service.dart';
import 'package:flutter/foundation.dart';

/// Service for centralized error handling, logging, and reporting.
abstract class ErrorHandlerService {
  /// Handle an error and optionally report it.
  void handleError(
    Object error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ]);

  /// Log an error without user-facing action.
  void logError(
    Object error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ]);

  /// Report a Failure with full context.
  void reportFailure(Failure failure);
}

class ErrorHandlerServiceImpl implements ErrorHandlerService {
  ErrorHandlerServiceImpl({
    required this.analyticsService,
    required this.crashlyticsService,
  });

  final AnalyticsService analyticsService;
  final CrashlyticsService crashlyticsService;

  @override
  void handleError(
    Object error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ]) {
    final failure = error is Failure
        ? error
        : Failure.fromException(error, stackTrace);

    _logToConsole(failure, stackTrace);
    _reportToAnalytics(failure, context);
    _reportToCrashlytics(failure, stackTrace);
  }

  @override
  void logError(
    Object error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ]) {
    final failure = error is Failure
        ? error
        : Failure.fromException(error, stackTrace);

    _logToConsole(failure, stackTrace);

    // Only report high severity errors silently
    if (failure.severity == ErrorSeverity.high ||
        failure.severity == ErrorSeverity.critical) {
      _reportToAnalytics(failure, context);
      _reportToCrashlytics(failure, stackTrace);
    }
  }

  @override
  void reportFailure(Failure failure) {
    _logToConsole(failure, failure.stackTrace);
    _reportToAnalytics(failure, failure.context);
    _reportToCrashlytics(failure, failure.stackTrace);
  }

  void _logToConsole(Failure failure, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔴 ERROR: ${failure.message}');
      debugPrint('   Type: ${failure.type.name}');
      debugPrint('   Severity: ${failure.severity.name}');
      if (failure.statusCode != null) {
        debugPrint('   Status Code: ${failure.statusCode}');
      }
      if (failure.technicalMessage != null) {
        debugPrint('   Technical: ${failure.technicalMessage}');
      }
      if (failure.context.isNotEmpty) {
        debugPrint('   Context: ${failure.context}');
      }
      if (stackTrace != null) {
        debugPrint('   Stack Trace:');
        debugPrint('   $stackTrace');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  void _reportToAnalytics(Failure failure, Map<String, dynamic>? context) {
    analyticsService.captureEvent('error_occurred', {
      'message': failure.message,
      'type': failure.type.name,
      'severity': failure.severity.name,
      'status_code': failure.statusCode ?? 0,
      'is_recoverable': failure.isRecoverable,
      if (failure.technicalMessage != null)
        'technical_message': failure.technicalMessage!,
      if (context != null)
        ...context.map((key, value) => MapEntry(key, value as Object)),
    });
  }

  void _reportToCrashlytics(Failure failure, StackTrace? stackTrace) {
    crashlyticsService
      ..setCustomKey('error_type', failure.type.name)
      ..setCustomKey('error_severity', failure.severity.name)
      ..recordError(
        failure,
        stackTrace ?? failure.stackTrace ?? StackTrace.current,
        reason: failure.technicalMessage ?? failure.message,
        fatal: failure.severity == ErrorSeverity.critical,
      );
  }
}
