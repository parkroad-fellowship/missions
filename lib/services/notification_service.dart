import 'package:app/enums/prf_notification_type.dart';
import 'package:app/enums/prf_time_of_day.dart';
import 'package:app/features/home/cubit/save_prayer_response_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  void scheduleGivingNotification();
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Logger().d(receivedNotification);
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Logger().d(receivedNotification);
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Logger().d(receivedAction);
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
              final l10n = context.l10n;

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
                                  l10n.prayerAlert,
                                  style: PRFText.theme()
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
                                  style: PRFText.theme().bodySmall?.copyWith(
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
                                    title: l10n.amen,
                                    disabled: false,
                                    onPressed: () {
                                      context
                                          .read<SavePrayerResponseCubit>()
                                          .savePrayerResponse(
                                            prayerPromptUlid:
                                                payload['prayer_prompt_ulid']!,
                                          )
                                          .then(
                                        (_) {
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      );
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
        NotificationChannel(
          channelKey: 'giving_prompts',
          channelName: 'Giving Prompts',
          channelDescription: 'Notify members to give towards the fellowship',
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
          autoDismissible: false,
          id: int.parse('${prayerPrompt.dayOfWeek}${prayerPrompt.timeOfDay}'),
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
        schedule: NotificationCalendar(
          weekday: prayerPrompt.dayOfWeek,
          hour: PRFTimeOfDay.fromIndex(prayerPrompt.timeOfDay).hour,
          repeats: true,
        ),
      );
    }
  }

  @override
  void scheduleGivingNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        autoDismissible: false,
        id: 111001,
        channelKey: 'giving_prompts',
        title: 'PRF: Support',
        body: 'Consider supporting the fellowship with your giving',
        payload: {
          'type': 'giving_prompt',
        },
      ),
      // Show this notification every Fridy at 1250 Hours
      schedule: NotificationCalendar(
        weekday: 5,
        hour: 12,
        minute: 50,
        repeats: true,
      ),
    );
  }
}
