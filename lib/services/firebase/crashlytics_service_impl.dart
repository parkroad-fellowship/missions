import 'package:app/enums/common/prf_environment.dart';
import 'package:app/services/firebase/crashlytics_service.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Firebase Crashlytics implementation of [CrashlyticsService].
///
/// Only reports errors in release mode AND production environment.
class CrashlyticsServiceImpl implements CrashlyticsService {
  CrashlyticsServiceImpl() : _crashlytics = FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;
  final Logger _logger = Logger();

  /// Only report in release mode AND production environment.
  bool get _shouldReport =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment ==
          PRFEnvironment.production;

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_shouldReport) {
      _logger.d('Crashlytics disabled: recordError($error)');
      return;
    }

    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!_shouldReport) {
      _logger.d('Crashlytics disabled: setCustomKey($key, $value)');
      return;
    }

    await _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String userId) async {
    if (!_shouldReport) {
      _logger.d('Crashlytics disabled: setUserId($userId)');
      return;
    }

    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> log(String message) async {
    if (!_shouldReport) {
      _logger.d('Crashlytics disabled: log($message)');
      return;
    }

    await _crashlytics.log(message);
  }
}
