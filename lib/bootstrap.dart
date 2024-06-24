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

    final hostOptions = PusherChannelsOptions.fromHost(
      scheme: 'ws',
      host: PRFSuperAppConfig.instance!.values.baseDomain,
      key: PRFSuperAppConfig.instance!.values.socketKey,
      port: 8080,
    );
// prints wss://my.domain.com:443/app/my_key?client=dart&version=0.8.0&protocol=7

    Logger().e(hostOptions.uri);

    final client = PusherChannelsClient.websocket(
      options: hostOptions,
      connectionErrorHandler: (exception, trace, refresh) {
        refresh();
      },
      activityDurationOverride: const Duration(
        seconds: 120,
      ),
    );

    final myPrivateChannel = client.privateChannel(
      'private-App.Models.User.01j15rmk017dz0z3eapt63p0gp',
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: Uri.parse(
          '${PRFSuperAppConfig.instance!.values.urlScheme}://${PRFSuperAppConfig.instance!.values.baseDomain}/broadcasting/auth',
        ),
        headers: const {},
      ),
    );

    final allChannels = <Channel>[
      myPrivateChannel,
    ];

    client.onConnectionEstablished.listen((_) {
      for (final channel in allChannels) {
        channel.subscribeIfNotUnsubscribed();
      }
    });

    myPrivateChannel.bind('CoolBeans').listen((event) {
      Logger().i('Event from the private channel fired!');
      Logger().e(event);
    });

    await client.connect();

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
