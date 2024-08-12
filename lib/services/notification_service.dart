import 'dart:math';

import 'package:app/enums/prf_notification_type.dart';
import 'package:app/enums/prf_time_of_day.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.dart';
import 'package:app/utils/singletons.dart';
import 'package:app/widgets/_index.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

abstract class NotificationService {
  void init();

  void requestPermissions();

  void createNotification({
    required NotificationContent content,
  });
  void schedulePrayerPromptNotifications({
    required List<PRFPrayerPrompt> prayerPrompts,
  });
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    Logger().d(receivedNotification);
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    Logger().d(receivedNotification);
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    Logger().d(receivedAction);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    Logger().f(receivedAction);

    final payload = receivedAction.payload;

    if (payload != null) {
      switch (PRFNotificationType.fromType(payload['type']!)) {
        case PRFNotificationType.prayerPrompt:
          await showDialog<dynamic>(
            context: getIt<PRFSuperAppRouter>().navigatorKey.currentContext!,
            builder: (context) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppTheme.appTheme().kPrimaryColorV2,
                                ),
                                title: Text(
                                  'Prayer Alert',
                                  style: CustomTextTheme.customTextTheme()
                                      .displayMedium
                                      ?.copyWith(
                                        color:
                                            AppTheme.appTheme().kPrimaryColorV2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  payload['prayer_prompt_description']!,
                                  style: CustomTextTheme.customTextTheme()
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            AppTheme.appTheme().kPrimaryColorV2,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                              OverflowBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  PrimaryButton(
                                    title: 'Amen',
                                    disabled: false,
                                    onPressed: () {
                                      // Tell the server I have prayed
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
      }
    }
  }
}

class NotificationServiceImpl implements NotificationService {
  @override
  void init() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
        ),
        NotificationChannel(
          channelKey: 'prayer_prompts',
          channelName: 'Prayer Prompts',
          channelDescription: 'Notify members to pray',
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        ),
      ],
      debug: true,
    );
  }

  @override
  void requestPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  void createNotification({
    required NotificationContent content,
  }) {
    AwesomeNotifications().createNotification(
      content: content,
    );
  }

  @override
  void schedulePrayerPromptNotifications({
    required List<PRFPrayerPrompt> prayerPrompts,
  }) {
    for (final prayerPrompt in prayerPrompts) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(356),
          channelKey: 'prayer_prompts',
          title: 'PRF: Prayer watch',
          body: prayerPrompt.description,
          payload: {
            'type': 'prayer_prompt',
            'prayer_prompt_ulid': prayerPrompt.ulid,
            'prayer_prompt_description': prayerPrompt.description,
          },
        ),
        // Show this notification at a particular time of day

        // schedule: NotificationCalendar(
        //   // weekday: prayerPrompt.dayOfWeek,
        //   // hour: PRFTimeOfDay.fromIndex(prayerPrompt.timeOfDay).hour,
        //   repeats: true,
        // ),
      );
    }
  }
}
