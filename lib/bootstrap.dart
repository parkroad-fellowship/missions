import 'dart:async';
import 'dart:developer';

import 'package:app/firebase_options.dart';
import 'package:app/models/remote/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz_data;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  try {
    Bloc.observer = const AppBlocObserver();

    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString(
        'assets/google_fonts/OFL.txt',
      );
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    tz_data.initializeTimeZones();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Ensure timezone data is loaded
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));

    // Report errors to Crashlytics in release mode only
    if (kReleaseMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    Singletons.setup();
    await Singletons.setupDatabase();

    await getIt<HiveService>().initBoxes();

    try {
      await getIt<AuthService>().initRemoteConfig();
    } catch (e) {
      Logger().e(e);
    }

    await getIt<AnalyticsService>().init();

    final user = getIt<HiveService>().retrieveProfile();

    if (user != null) {
      final defaultConfig = getIt<SocketService>().defaultConfig();

      try {
        await getIt<SocketService>().init(
          socketConfig: SocketConfig(
            privateChannels: defaultConfig.privateChannels,
            presenceChannels: defaultConfig.presenceChannels,
          ),
        );
      } catch (e) {
        Logger().e('SocketService init error: $e');
      }

      await getIt<AnalyticsService>().identifyUser(user: user);
    }

    await getIt<MediaService>().initDownloader();

    try {
      await getIt<NotificationService>().init();
      await getIt<NotificationService>().requestPermissions();
      await getIt<NotificationService>().scheduleGivingNotification();
      
    } catch (e) {
      Logger().e('NotificationService init error: $e');
    }

    runApp(await builder());
  } catch (error, stackTrace) {
    log(error.toString(), stackTrace: stackTrace);
  }
}
