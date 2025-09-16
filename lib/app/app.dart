import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/shared_widgets/global_failed_uploads_banner.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PRFSuperApp extends StatefulWidget {
  const PRFSuperApp({super.key});

  @override
  State<PRFSuperApp> createState() => _PRFSuperAppState();
}

class _PRFSuperAppState extends State<PRFSuperApp> {
  @override
  Widget build(BuildContext context) {
    return PostHogWidget(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: PRFTheme.light(context),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: getIt<PRFSuperAppRouter>().config(),
        builder: (context, child) {
          return GlobalFailedUploadsBanner(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
