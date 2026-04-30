import 'package:app/enums/common/prf_environment.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/services/analytics/analytics_service.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// PostHog implementation of [AnalyticsService].
///
/// Only collects data in release mode AND production environment.
class PostHogAnalyticsService implements AnalyticsService {
  final Logger _logger = Logger();

  /// Only collect in release mode AND production environment.
  bool get _shouldCollect =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment ==
          PRFEnvironment.production;

  @override
  Future<void> init() async {
    if (!_shouldCollect) {
      _logger.d('PostHog Analytics disabled (not release/production)');
      return;
    }

    final config =
        PostHogConfig(PRFSuperAppConfig.instance!.values.postHogKey)
          ..host = 'https://eu.i.posthog.com'
          ..debug = false
          ..captureApplicationLifecycleEvents = true
          ..sessionReplay = true;

    config.sessionReplayConfig.maskAllTexts = false;
    config.sessionReplayConfig.maskAllImages = false;

    await Posthog().setup(config);
  }

  @override
  Future<void> captureEvent(
    String eventName, [
    Map<String, Object>? props,
  ]) async {
    if (!_shouldCollect) {
      _logger.d('Analytics disabled: captureEvent($eventName)');
      return;
    }

    if (props != null) {
      await Posthog().capture(eventName: eventName, properties: props);
    } else {
      await Posthog().capture(eventName: eventName);
    }
  }

  @override
  Future<void> identifyUser({required PRFUser user}) async {
    if (!_shouldCollect) {
      _logger.d('Analytics disabled: identifyUser(${user.email})');
      return;
    }

    await Posthog().identify(
      userId: user.email,
      userProperties: {'name': user.name, 'email': user.email},
      userPropertiesSetOnce: {
        'date_of_first_log_in': DateTime.now().toIso8601String(),
      },
    );
  }
}
