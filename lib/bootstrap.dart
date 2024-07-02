import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/models/remote/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
  await runZonedGuarded(() async {
    Bloc.observer = const AppBlocObserver();

    await getIt<HiveService>().initBoxes();

    final userUlid = getIt<HiveService>().retrieveProfile()?.ulid;

    if (userUlid != null) {
      final defaultConfig = getIt<SocketService>().defaultConfig();

      await getIt<SocketService>().init(
        socketConfig: SocketConfig(
          privateChannels: defaultConfig.privateChannels,
          presenceChannels: defaultConfig.presenceChannels,
        ),
      );
    }

    getIt<NotificationService>().init();

    await Firebase.initializeApp(
      options:
          Platform.isAndroid ? DefaultFirebaseOptions.currentPlatform : null,
    );

    runApp(await builder());
  }, (error, stackTrace) {
    if (kDebugMode) {
      log(error.toString(), stackTrace: stackTrace);
    } else {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  });
}
