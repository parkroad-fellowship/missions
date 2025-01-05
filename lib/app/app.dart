import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
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
      builder: (context, child) => ValueListenableBuilder<dynamic>(
        valueListenable: Hive.box<dynamic>(
          PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
        ).listenable(),
        builder: (context, _, __) {
          final isLoggedOut = getIt<HiveService>().isLoggedOut();
          Logger().e('isLoggedOut: $isLoggedOut');
          if (isLoggedOut) {
            getIt<PRFSuperAppRouter>().pushNamed(
              PRFSuperAppRouter.decisionRoute,
            );
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: AppTheme.appTheme().kPrimaryColorV2,
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
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
