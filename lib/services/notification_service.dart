import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_notification_type.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_prompt.dart';
import 'package:app/models/remote/prayer/prf_prayer_response.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';

import 'package:app/utils/router/router.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:prf_design/prf_design.dart';

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
    // Just log - notification is already created, don't create another one
    Logger().d('Notification created: ${receivedNotification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Just log - notification is already displayed, don't create another one
    Logger().d('Notification displayed: ${receivedNotification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // User dismissed the notification - just log, don't navigate
    Logger().d('Notification dismissed: ${receivedAction.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    Logger().f(receivedAction);
    await _act(receivedAction.payload);
  }

  static Future<void> _act(Map<String, String?>? payload) async {
    final context = getIt<PRFSuperAppRouter>().navigatorKey.currentContext;

    if (payload == null) {
      Logger().w('Notification payload is null');
    }

    if (context == null) {
      Logger().w('No context available for notification action');
      return;
    }

    if (payload != null && payload['type'] == null) {
      Logger().w('Notification payload type is null');
      return;
    }

    if (payload != null) {
      switch (PRFNotificationType.fromType(payload['type']!)) {
        case PRFNotificationType.defaultPrompt:
          Logger().i('Default prompt received');
          return;

        case PRFNotificationType.prayerPrompt:
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
          ]);
          await showDialog<dynamic>(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              final l10n = context.l10n;
              return Center(
                child: Material(
                  color: PRFColors.transparent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Card(
                        color: PRFColors.white,
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
                                    onPressed: () async {
                                      final member = getIt<HiveService>()
                                          .retrieveMember();
                                      if (member != null) {
                                        await getIt<HiveService>()
                                            .prayerResponses
                                            .persistEntities(
                                              [
                                                PRFPrayerResponseDTO(
                                                  prayerPromptUlid:
                                                      payload['prayer_prompt_ulid']!,
                                                  memberUlid: member.ulid,
                                                ),
                                              ],
                                            );
                                      }

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
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
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
            const GivingRoute(),
          ]);

        case PRFNotificationType.cancelledMission:
        case PRFNotificationType.postponedMission:
        case PRFNotificationType.missionThankYou:
        case PRFNotificationType.missionWhatsappGroupCreated:
        case PRFNotificationType.missionSubscription:
        case PRFNotificationType.newMission:
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
            const MissionsRoute(),
            MissionsDetailsRoute(
              missionUlid: payload['mission_ulid']!,
            ),
          ]);

        case PRFNotificationType.newEvent:
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
            const EventsRoute(),
          ]);
        case PRFNotificationType.studentEnquiry:
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
            const StudentEnquiriesRoute(),
          ]);
        case PRFNotificationType.studentEnquiryReply:
          await getIt<PRFSuperAppRouter>().replaceAll([
            const LandingRoute(),
            const StudentEnquiriesRoute(),
            StudentEnquiryRepliesRoute(
              enquiryUlid: payload['student_enquiry_ulid']!,
            ),
          ]);
      }
    }
  }
}

class NotificationServiceImpl implements NotificationService {
  @override
  Future<void> init() async {
    final notificationsEnabled = getIt<HiveService>().settings
        .areNotificationsEnabled();
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
      debug: kDebugMode,
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

    await scheduleGivingNotification();
  }

  @override
  Future<void> requestPermissions() async {
    final hiveService = getIt<HiveService>().settings;
    final notificationsEnabled = hiveService.areNotificationsEnabled();
    final hasBeenRequested = hiveService.hasPermissionBeenRequested();

    // Don't show dialog if notifications are disabled or already requested
    if (!notificationsEnabled || hasBeenRequested) return;

    var userAuthorized = false;
    final context = getIt<PRFSuperAppRouter>().navigatorKey.currentContext;
    if (context == null) return;
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.getNotified),
          content: Text(l10n.allowNotifications),
          actions: [
            PRFSecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              title: l10n.deny,
              disabled: false,
            ),
            const SizedBox(height: 16),
            PRFPrimaryButton(
              onPressed: () {
                userAuthorized = true;
                Navigator.of(context).pop();
              },
              title: l10n.allow,
              disabled: false,
            ),
          ],
        );
      },
    );

    // Mark that permission has been requested
    hiveService.setPermissionRequested(requested: true);

    if (userAuthorized) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      hiveService.toggleNotifications(enable: true);
    } else {
      hiveService.toggleNotifications(enable: false);
    }
  }

  @override
  void createNotification({required NotificationContent content}) {
    final notificationsEnabled = getIt<HiveService>().settings
        .areNotificationsEnabled();
    if (!notificationsEnabled) return;
    AwesomeNotifications().createNotification(content: content);
  }

  @override
  Future<void> schedulePrayerPromptNotifications({
    required List<PRFPrayerPrompt> prayerPrompts,
  }) async {
    // final notificationsEnabled = getIt<HiveService>().settings
    //     .areNotificationsEnabled();
    // if (!notificationsEnabled) return;
    // await AwesomeNotifications().cancelAllSchedules();
    // for (final prayerPrompt in prayerPrompts) {
    //   await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       autoDismissible: false,
    //       id: int.parse('${prayerPrompt.dayOfWeek}${prayerPrompt.timeOfDay}'),
    //       channelKey: 'prayer_prompts',
    //       title: 'PRF: Prayer watch',
    //       body: prayerPrompt.description,
    //       payload: {
    //         'type': 'prayer_prompt',
    //         'prayer_prompt_ulid': prayerPrompt.ulid,
    //         'prayer_prompt_description': prayerPrompt.description,
    //       },
    //     ),
    //     // Show this notification at a particular time of day
    //     schedule: NotificationCalendar(
    //       weekday: prayerPrompt.dayOfWeek,
    //       hour: PRFTimeOfDay.fromIndex(prayerPrompt.timeOfDay).hour,
    //       minute: 0,
    //       second: 0,
    //       repeats: true,
    //       allowWhileIdle: true,
    //       timeZone: _timezone,
    //     ),
    //   );
    // }
  }

  @override
  Future<void> scheduleGivingNotification() async {
    // final notificationsEnabled = getIt<HiveService>().settings
    //     .areNotificationsEnabled();
    // if (!notificationsEnabled) return;
    // await AwesomeNotifications().cancelAllSchedules();
    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     autoDismissible: false,
    //     id: 111001,
    //     channelKey: 'giving_prompts',
    //     title: 'PRF: Support',
    //     body: 'Consider supporting the fellowship with your giving',
    //     payload: {'type': 'giving_prompt'},
    //   ),
    //   // Show this notification every Friday at 1250 Hours
    //   schedule: NotificationCalendar(
    //     weekday: 5,
    //     hour: 12,
    //     minute: 50,
    //     second: 0,
    //     repeats: true,
    //     allowWhileIdle: true,
    //     timeZone: _timezone,
    //   ),
    // );
  }

  // String get _timezone => tz.local.name;
}
