import 'dart:async';
import 'dart:developer';

import 'package:app/di/di_container.dart';
import 'package:app/firebase_options.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/common/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/http/request_signer.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
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
        'packages/prf_design/assets/google_fonts/lato/OFL.txt',
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
      final patch = await ShorebirdUpdater().readCurrentPatch();
      await FirebaseCrashlytics.instance.setCustomKey(
        'shorebird_patch_number',
        '${patch?.number}',
      );

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    DIContainer.setup();
    await DIContainer.initializeDatabases();

    await RequestSigner.syncWithServer(
      PRFSuperAppConfig.instance!.values.baseUrl,
    );

    try {
      await getIt<PRFFirebaseService>().initRemoteConfig();
    } catch (e) {
      Logger().e(e);
    }

    await getIt<AnalyticsService>().init();

    final user = getIt<HiveService>().auth.retrieveProfile();

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

      try {
        final fcmToken = await getIt<FirebaseMessagingService>()
            .retrieveFCMToken();
        if (fcmToken.isNotEmpty) {
          await getIt<AuthService>().updateProfile(
            updateDTO: UserUpdateDTO(
              fcmTokens: [fcmToken],
            ),
          );
        }
      } catch (e) {
        Logger().e('Firebase Messaging init error: $e');
      }
    }

    await getIt<MediaService>().initDownloader();

    runApp(await builder());
  } catch (error, stackTrace) {
    log(error.toString(), stackTrace: stackTrace);
  }
}
