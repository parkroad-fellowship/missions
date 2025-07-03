import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PRFSuperApp extends StatefulWidget {
  const PRFSuperApp({super.key});

  @override
  State<PRFSuperApp> createState() => _PRFSuperAppState();
}

class _PRFSuperAppState extends State<PRFSuperApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1290, 2796),
      builder: (context, child) => ValueListenableBuilder<dynamic>(
        valueListenable: Hive.box<dynamic>(
          PRFSuperAppConfig.instance!.values.globalHiveAuthBox,
        ).listenable(),
        builder: (context, _, _) {
          final isLoggedOut = getIt<HiveService>().auth.isLoggedOut();
          Logger().e('isLoggedOut: $isLoggedOut');
          if (isLoggedOut) {
            getIt<PRFSuperAppRouter>().pushNamed(
              PRFSuperAppRouter.decisionRoute,
            );
          }

          final textTheme = PRFTextTheme.getLightTheme(context);
          final scaleFactor = Misc.getScaleFactor(context);

          return PostHogWidget(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: PRFTheme.light.copyWith(
                textTheme: textTheme,
                appBarTheme: PRFTheme.light.appBarTheme.copyWith(
                  titleTextStyle: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                dropdownMenuTheme: PRFTheme.light.dropdownMenuTheme.copyWith(
                  textStyle: textTheme.bodyMedium,
                ),
                tabBarTheme: PRFTheme.light.tabBarTheme.copyWith(
                  labelStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(PRFTheme.primaryColor),
                  ),
                  unselectedLabelStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff6c757d),
                  ),
                ),
                inputDecorationTheme: PRFTheme.light.inputDecorationTheme
                    .copyWith(
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff6c757d),
                      ),
                      labelStyle: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff6c757d),
                      ),
                      errorStyle: PRFTextTheme.getErrorTextStyle(context),
                    ),
                dataTableTheme: PRFTheme.light.dataTableTheme.copyWith(
                  dataTextStyle: textTheme.bodyMedium,
                  headingTextStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                snackBarTheme: PRFTheme.light.snackBarTheme.copyWith(
                  contentTextStyle: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                iconTheme: PRFTheme.light.iconTheme.copyWith(
                  size: 24 * scaleFactor,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: PRFTheme.light.elevatedButtonTheme.style?.copyWith(
                    textStyle: WidgetStateProperty.all(
                      PRFTextTheme.getButtonTextStyle(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: PRFTheme.light.outlinedButtonTheme.style?.copyWith(
                    textStyle: WidgetStateProperty.all(
                      PRFTextTheme.getButtonTextStyle(context).copyWith(
                        color: const Color(PRFTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: PRFTheme.light.textButtonTheme.style?.copyWith(
                    textStyle: WidgetStateProperty.all(
                      PRFTextTheme.getButtonTextStyle(context).copyWith(
                        color: const Color(PRFTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
                dialogTheme: PRFTheme.light.dialogTheme.copyWith(
                  titleTextStyle: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  contentTextStyle: textTheme.bodyMedium,
                ),
                listTileTheme: PRFTheme.light.listTileTheme.copyWith(
                  titleTextStyle: textTheme.bodyLarge,
                  subtitleTextStyle: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xff6c757d),
                  ),
                ),
                chipTheme: PRFTheme.light.chipTheme.copyWith(
                  labelStyle: textTheme.labelMedium,
                  secondaryLabelStyle: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: getIt<PRFSuperAppRouter>().config(),
            ),
          );
        },
      ),
    );
  }
}
