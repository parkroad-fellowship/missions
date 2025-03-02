import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/app_theme.dart';
import 'package:app/utils/text_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class PRFSuperApp extends StatefulWidget {
  const PRFSuperApp({super.key});

  @override
  State<PRFSuperApp> createState() => _PRFSuperAppState();
}

class _PRFSuperAppState extends State<PRFSuperApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );

    getIt<NotificationService>().requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1290, 2796),
      builder:
          (context, child) => ValueListenableBuilder<dynamic>(
            valueListenable:
                Hive.box<dynamic>(
                  PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
                ).listenable(),
            builder: (context, _, _) {
              final isLoggedOut = getIt<HiveService>().isLoggedOut();
              Logger().e('isLoggedOut: $isLoggedOut');
              if (isLoggedOut) {
                getIt<PRFSuperAppRouter>().pushNamed(
                  PRFSuperAppRouter.decisionRoute,
                );
              }

              final textTheme = PRFTextTheme.getLightTheme(context);

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: PRFTheme.light.copyWith(
                  textTheme: textTheme,
                  dropdownMenuTheme: PRFTheme.light.dropdownMenuTheme.copyWith(
                    textStyle: textTheme.bodySmall,
                  ),
                  tabBarTheme: PRFTheme.light.tabBarTheme.copyWith(
                    labelStyle: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(PRFTheme.primaryColor),
                    ),
                    unselectedLabelStyle: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  inputDecorationTheme: PRFTheme.light.inputDecorationTheme
                      .copyWith(
                        hintStyle: textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                        labelStyle: textTheme.bodySmall,
                      ),
                  dataTableTheme: PRFTheme.light.dataTableTheme.copyWith(
                    dataTextStyle: textTheme.bodyMedium,
                    headingTextStyle: textTheme.headlineMedium,
                  ),
                  snackBarTheme: PRFTheme.light.snackBarTheme.copyWith(
                    contentTextStyle: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  iconTheme: PRFTheme.light.iconTheme.copyWith(
                    size: 24 * Misc.getScaleFactor(context),
                  ),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: getIt<PRFSuperAppRouter>().config(),
              );
            },
          ),
    );
  }
}
