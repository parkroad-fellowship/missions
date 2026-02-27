import 'package:app/features/home/shared/cubit/theme_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PRFSuperApp extends StatelessWidget {
  const PRFSuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PostHogWidget(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeMode = context.read<ThemeCubit>().currentThemeMode;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: PRFTheme.light(context),
            darkTheme: PRFTheme.dark(context),
            themeMode: themeMode.toFlutterThemeMode(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: getIt<PRFSuperAppRouter>().config(),
          );
        },
      ),
    );
  }
}
