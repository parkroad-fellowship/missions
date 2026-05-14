import 'package:app/di/_index.dart';
import 'package:app/features/home/shared/cubit/theme_cubit.dart';
import 'package:app/features/home/shared/widgets/global_recording_uploads_bar.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/utils/_index.dart' hide DeviceHelper;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:prf_design/prf_design.dart';

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
            theme: PRFTheme.light(
              scaleFactor: DeviceHelper.getScaleFactor(context: context),
            ),
            darkTheme: PRFTheme.dark(
              scaleFactor: DeviceHelper.getScaleFactor(context: context),
            ),
            themeMode: themeMode.toFlutterThemeMode(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: getIt<PRFSuperAppRouter>().config(),
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  const Positioned.fill(
                    child: GlobalRecordingUploadsBar(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
