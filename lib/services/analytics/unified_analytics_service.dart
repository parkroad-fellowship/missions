import 'package:app/enums/common/prf_environment.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/services/analytics/_analytics_service.dart';
import 'package:app/utils/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Unified analytics implementation that sends data to both PostHog and Firebase.
class UnifiedAnalyticsService implements AnalyticsService {
  UnifiedAnalyticsService({
    FirebaseAnalytics? firebaseAnalytics,
    Logger? logger,
  }) : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics.instance,
       _logger = logger ?? Logger(),
       _firebaseObserver = FirebaseAnalyticsObserver(
         analytics: firebaseAnalytics ?? FirebaseAnalytics.instance,
       );

  final FirebaseAnalytics _firebaseAnalytics;
  final Logger _logger;
  final FirebaseAnalyticsObserver _firebaseObserver;

  /// Only collect in release mode AND production environment.
  bool get _shouldCollect =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment ==
          PRFEnvironment.production;

  @override
  List<NavigatorObserver> get navigatorObservers => _shouldCollect
      ? [
          _firebaseObserver, // Firebase Analytics observer for automatic screen tracking
          ...AutoRouterDelegate.defaultNavigatorObserversBuilder(), // Include AutoRoute's default observers for compatibility with PostHog's screen tracking
        ]
      : const [];

  @override
  Future<void> init() async {
    if (!_shouldCollect) {
      _logDisabled('init');
      return;
    }

    final config = PostHogConfig(PRFSuperAppConfig.instance!.values.postHogKey)
      ..host = 'https://eu.i.posthog.com'
      ..debug = false
      ..captureApplicationLifecycleEvents = true
      ..sessionReplay = true;

    config.sessionReplayConfig.maskAllTexts = false;
    config.sessionReplayConfig.maskAllImages = false;

    await Posthog().setup(config);
  }

  @override
  Future<void> identifyUser({required PRFUser user}) async {
    if (!_shouldCollect) {
      _logDisabled('identifyUser', user.email);
      return;
    }

    await Future.wait([
      Posthog().identify(
        userId: user.email,
        userProperties: {'name': user.name, 'email': user.email},
        userPropertiesSetOnce: {
          'date_of_first_log_in': DateTime.now().toIso8601String(),
        },
      ),
      _firebaseAnalytics.setUserId(id: user.email),
    ]);
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!_shouldCollect) {
      _logDisabled('setUserId', userId ?? 'null');
      return;
    }

    await _firebaseAnalytics.setUserId(id: userId);

    if (userId != null && userId.isNotEmpty) {
      await Posthog().identify(
        userId: userId,
        userProperties: {'email': userId},
      );
    }
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    if (!_shouldCollect) {
      _logDisabled('logEvent', name);
      return;
    }

    final normalized = _normalizeParameters(parameters);

    await Future.wait([
      Posthog().capture(
        eventName: name,
        properties: normalized.isEmpty ? null : normalized,
      ),
      _firebaseAnalytics.logEvent(
        name: name,
        parameters: normalized.isEmpty ? null : normalized,
      ),
    ]);
  }

  @override
  Future<void> captureEvent(
    String eventName, [
    Map<String, Object>? props,
  ]) {
    final parameters = props?.map<String, Object?>((key, value) {
      return MapEntry(key, value);
    });
    return logEvent(eventName, parameters: parameters);
  }

  @override
  Future<void> logScreenView({required String screenName}) async {
    if (!_shouldCollect) {
      _logDisabled('logScreenView', screenName);
      return;
    }

    await Future.wait([
      _firebaseAnalytics.logScreenView(screenName: screenName),
      Posthog().capture(
        eventName: 'screen_view',
        properties: {'screen_name': screenName},
      ),
    ]);
  }

  @override
  Future<void> logException({
    required String description,
    bool fatal = false,
    Map<String, Object?>? parameters,
  }) {
    final params = <String, Object?>{
      'description': description,
      'fatal': fatal,
      ...?parameters,
    };

    return logEvent('exception', parameters: params);
  }

  Map<String, Object> _normalizeParameters(Map<String, Object?>? parameters) {
    final normalized = <String, Object>{};
    if (parameters == null) {
      return normalized;
    }

    for (final entry in parameters.entries) {
      final value = entry.value;
      if (value != null) {
        normalized[entry.key] = value;
      }
    }

    return normalized;
  }

  void _logDisabled(String action, [String? detail]) {
    if (detail == null || detail.isEmpty) {
      _logger.d('Analytics disabled: $action');
      return;
    }

    _logger.d('Analytics disabled: $action($detail)');
  }
}
