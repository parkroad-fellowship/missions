import 'dart:async';

import 'package:app/enums/common/prf_environment.dart';
import 'package:app/enums/error_severity.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/analytics/_analytics_service.dart';
import 'package:app/services/errors/_error_reporting_service.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Unified error reporting service that fans out to all enabled platforms.
class UnifiedErrorReportingService implements ErrorReportingService {
  UnifiedErrorReportingService({
    required this._analyticsService,
  }) : _crashlytics = FirebaseCrashlytics.instance;

  final AnalyticsService _analyticsService;
  final FirebaseCrashlytics _crashlytics;
  final Logger _logger = Logger();

  bool get _shouldReport =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment ==
          PRFEnvironment.production;

  @override
  Future<void> reportFailure(
    Failure failure, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    if (!_shouldReport) {
      _logger.d(
        'Error reporting disabled: reportFailure(${failure.type.name})',
        stackTrace: stackTrace,
      );
      return;
    }

    final effectiveStackTrace =
        stackTrace ?? failure.stackTrace ?? StackTrace.current;
    final isFatal = failure.severity == ErrorSeverity.critical;

    await _analyticsService.logEvent(
      'error_occurred',
      parameters: {
        'message': failure.message,
        'type': failure.type.name,
        'severity': failure.severity.name,
        'status_code': failure.statusCode ?? 0,
        'is_recoverable': failure.isRecoverable,
        if (failure.technicalMessage != null)
          'technical_message': failure.technicalMessage,
        if (context != null)
          ...context.map(
            (key, value) => MapEntry(key, value?.toString() ?? 'null'),
          ),
      },
    );

    await _analyticsService.logException(
      description: failure.technicalMessage ?? failure.message,
      fatal: isFatal,
      parameters: {
        'type': failure.type.name,
        'severity': failure.severity.name,
      },
    );

    await _crashlytics.setCustomKey('error_type', failure.type.name);
    await _crashlytics.setCustomKey('error_severity', failure.severity.name);
    await _crashlytics.recordError(
      failure,
      effectiveStackTrace,
      reason: failure.technicalMessage ?? failure.message,
      fatal: isFatal,
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_shouldReport) {
      _logger.d(
        'Error reporting disabled: recordError($error)',
        stackTrace: stackTrace,
      );
      return;
    }

    await _analyticsService.logException(
      description: reason ?? error.toString(),
      fatal: fatal,
      parameters: {
        'error_type': error.runtimeType.toString(),
      },
    );

    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails errorDetails) async {
    if (!_shouldReport) {
      _logger.d(
        'Error reporting disabled: recordFlutterFatalError',
        stackTrace: errorDetails.stack,
      );
      return;
    }

    await _analyticsService.logException(
      description: errorDetails.exceptionAsString(),
      fatal: true,
      parameters: {
        'error_type': errorDetails.exception.runtimeType.toString(),
      },
    );

    await _crashlytics.recordFlutterFatalError(errorDetails);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!_shouldReport) {
      _logger.d('Error reporting disabled: setCustomKey($key, $value)');
      return;
    }

    await _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String userId) async {
    if (!_shouldReport) {
      _logger.d('Error reporting disabled: setUserId($userId)');
      return;
    }

    await _analyticsService.setUserId(userId);

    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> log(String message) async {
    if (!_shouldReport) {
      _logger.d('Error reporting disabled: log($message)');
      return;
    }

    await _analyticsService.logEvent(
      'error_log',
      parameters: {'message': message},
    );

    await _crashlytics.log(message);
  }
}
