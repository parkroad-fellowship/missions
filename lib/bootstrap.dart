import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

    getIt<NotificationService>().init();

    await Firebase.initializeApp(
      options:
          Platform.isAndroid ? DefaultFirebaseOptions.currentPlatform : null,
    );

    try {
      final wsUrl = Uri(
        scheme: 'ws',
        host: PRFSuperAppConfig.instance!.values.baseDomain,
        port: 8080,
        path: 'app/${PRFSuperAppConfig.instance!.values.socketKey}',
      );
      final channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;

      channel.stream.listen((message) {
        Logger().i('Received: $message');
      });
    } catch (e) {
      Logger().e(e);
    }

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
