import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

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

    // Socket connection
    
    final client = getIt<SocketService>().initClient();

    final notificationsChannel =
        getIt<SocketService>().registerToPrivateChannel(
      client: client,
      channelName: 'App.Models.User.01j15rmk017dz0z3eapt63p0gp',
    );

    getIt<SocketService>().bindEventToChannel(
      channel: notificationsChannel,
      eventName: r'App\Events\CoolBeans',
    );

    getIt<SocketService>().subscribeToPrivateChannelsEvent(
      client: client,
      channels: [
        notificationsChannel,
      ],
    );

    await getIt<SocketService>().connectClient(client: client);

    // End: Socket Connection

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
