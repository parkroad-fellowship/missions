import 'package:app/enums/prf_notification_type.dart';
import 'package:app/enums/prf_time_of_day.dart';
import 'package:app/features/home/cubit/save_prayer_response_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/buttons/secondary.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';

abstract class NotificationService {
  Future<void> init();

  Future<void> requestPermissions();

  void createNotification({required NotificationContent content});
  Future<void> schedulePrayerPromptNotifications({
    required List<PRFPrayerPrompt> prayerPrompts,
  });
  Future<void> scheduleGivingNotification();
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
        case PRFNotificationType.defaultPrompt:
          return;

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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  l10n.prayerAlert,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  payload['prayer_prompt_description']!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              OverflowBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  PRFSecondaryButton(
                                    title: l10n.amen,
                                    disabled: false,
                                    onPressed: () {
                                      context
                                          .read<SavePrayerResponseCubit>()
                                          .savePrayerResponse(
                                            prayerPromptUlid:
                                                payload['prayer_prompt_ulid']!,
                                          )
                                          .then((_) {
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                          });
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
        case PRFNotificationType.givingPrompt:
          await getIt<PRFSuperAppRouter>().pushNamed(
            PRFSuperAppRouter.givingRoute,
          );
      }
    }
  }
}

class NotificationServiceImpl implements NotificationService {
  @override
  Future<void> init() async {
    final notificationsEnabled = getIt<HiveService>().areNotificationsEnabled();
    if (!notificationsEnabled) return;
    await AwesomeNotifications().initialize(
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

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );
  }

  @override
  Future<void> requestPermissions() async {
    final notificationsEnabled = getIt<HiveService>().areNotificationsEnabled();
    if (!notificationsEnabled) return;

    var userAuthorized = false;
    final context = getIt<PRFSuperAppRouter>().navigatorKey.currentContext;
    if (context == null) return;
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.getNotified),
          content: Text(l10n.allowNotifications),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.deny,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                userAuthorized = true;
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.allow,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (userAuthorized) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      getIt<HiveService>().toggleNotifications(enable: true);
    } else {
      getIt<HiveService>().toggleNotifications(enable: false);
    }
  }

  @override
  void createNotification({required NotificationContent content}) {
    final notificationsEnabled = getIt<HiveService>().areNotificationsEnabled();
    if (!notificationsEnabled) return;
    AwesomeNotifications().createNotification(content: content);
  }

  @override
  Future<void> schedulePrayerPromptNotifications({
    required List<PRFPrayerPrompt> prayerPrompts,
  }) async {
    final notificationsEnabled = getIt<HiveService>().areNotificationsEnabled();
    if (!notificationsEnabled) return;
    for (final prayerPrompt in prayerPrompts) {
      await AwesomeNotifications().createNotification(
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
          minute: 0,
          second: 0,
          repeats: true,
          allowWhileIdle: true,
          timeZone: await _timezone,
        ),
      );
    }
  }

  @override
  Future<void> scheduleGivingNotification() async {
    final notificationsEnabled = getIt<HiveService>().areNotificationsEnabled();
    if (!notificationsEnabled) return;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        autoDismissible: false,
        id: 111001,
        channelKey: 'giving_prompts',
        title: 'PRF: Support',
        body: 'Consider supporting the fellowship with your giving',
        payload: {'type': 'giving_prompt'},
      ),
      // Show this notification every Fridy at 1250 Hours
      schedule: NotificationCalendar(
        weekday: 5,
        hour: 12,
        minute: 50,
        second: 0,
        repeats: true,
        allowWhileIdle: true,
        timeZone: await _timezone,
      ),
    );
  }

  Future<String> get _timezone => FlutterTimezone.getLocalTimezone();
}
