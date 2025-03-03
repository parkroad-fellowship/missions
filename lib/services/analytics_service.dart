import 'package:app/models/remote/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

abstract class AnalyticsService {
  Future<void> init();
  Future<void> identifyUser({
    required PRFUser user,
  });
  Future<void> captureEvent(String eventName, [Map<String, Object>? props]);
}

class AnalyticsServiceImpl implements AnalyticsService {
  @override
  Future<void> init() async {
    // if(kDebugMode) return;
    final config =
        PostHogConfig('phc_qMm6StosFNCMhAkrmcoJAOlX5kOhvVTR6dsCFCIkE3g')
          ..host = 'https://eu.i.posthog.com'
          ..debug = true
          ..captureApplicationLifecycleEvents = true
          // check https://posthog.com/docs/session-replay/installation?tab=Flutter
          // for more config and to learn about how we capture sessions on mobile
          // and what to expect
          ..sessionReplay = true;
    // choose whether to mask images or text
    config.sessionReplayConfig.maskAllTexts = false;
    config.sessionReplayConfig.maskAllImages = false;

    // Setup PostHog with the given Context and Config
    await Posthog().setup(config);
  }

  

  @override
  Future<void> captureEvent(
    String eventName, [
    Map<String, Object>? props,
  ]) async {
    //  if(kDebugMode) return;
    if (props != null) {
      await Posthog().capture(eventName: eventName, properties: props);
    } else {
      await Posthog().capture(eventName: eventName);
    }
  }
  
  @override
  Future<void> identifyUser({
    required PRFUser user,
  }) async {
   await Posthog().identify(
  userId: user.email, 
  userProperties: {"name": user.name, "email": user.email},
  userPropertiesSetOnce: {"date_of_first_log_in": DateTime.now().toIso8601String()},
);
  }
}
