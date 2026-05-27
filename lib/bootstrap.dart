import 'dart:async';
import 'dart:developer';

import 'package:app/di/di_container.dart';
import 'package:app/firebase_options.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/common/socket_config.dart';
import 'package:app/services/analytics/_analytics_service.dart';
import 'package:app/services/api/auth_service.dart';
import 'package:app/services/errors/_error_reporting_service.dart';
import 'package:app/services/firebase/firebase_messaging_service.dart';
import 'package:app/services/firebase/firebase_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:app/services/socket_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/http/request_signer.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
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

    DIContainer.setup();
    await DIContainer.initializeDatabases();

    if (kReleaseMode) {
      final patch = await ShorebirdUpdater().readCurrentPatch();
      await getIt<ErrorReportingService>().setCustomKey(
        'shorebird_patch_number',
        '${patch?.number}',
      );

      FlutterError.onError =
          getIt<ErrorReportingService>().recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(
          getIt<ErrorReportingService>().recordError(
            error,
            stack,
            fatal: true,
          ),
        );
        return true;
      };
    }

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
      await getIt<ErrorReportingService>().setUserId(user.email);

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
