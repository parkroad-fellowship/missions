import 'package:app/enums/common/prf_environment.dart';
import 'package:app/services/firebase/firebase_analytics_service.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Firebase Analytics implementation of [FirebaseAnalyticsService].
///
/// Only collects data in release mode AND production environment.
class FirebaseAnalyticsServiceImpl implements FirebaseAnalyticsService {
  FirebaseAnalyticsServiceImpl() : _analytics = FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;
  final Logger _logger = Logger();

  /// Only collect in release mode AND production environment.
  bool get _shouldCollect =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment ==
          PRFEnvironment.production;

  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    if (!_shouldCollect) {
      _logger.d('Firebase Analytics disabled: logEvent($name)');
      return;
    }

    await _analytics.logEvent(
      name: name,
      parameters: parameters?.cast<String, Object>(),
    );
  }

  @override
  Future<void> logScreenView({required String screenName}) async {
    if (!_shouldCollect) {
      _logger.d('Firebase Analytics disabled: logScreenView($screenName)');
      return;
    }

    await _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> logException({
    required String description,
    bool fatal = false,
    Map<String, Object?>? parameters,
  }) async {
    if (!_shouldCollect) {
      _logger.d('Firebase Analytics disabled: logException($description)');
      return;
    }

    final params = <String, Object>{
      'description': description,
      'fatal': fatal,
    };
    if (parameters != null) {
      for (final entry in parameters.entries) {
        if (entry.value != null) {
          params[entry.key] = entry.value!;
        }
      }
    }
    await _analytics.logEvent(name: 'exception', parameters: params);
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!_shouldCollect) {
      _logger.d('Firebase Analytics disabled: setUserId($userId)');
      return;
    }

    await _analytics.setUserId(id: userId);
  }
}
