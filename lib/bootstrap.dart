import 'dart:async';
import 'dart:developer';

import 'package:app/firebase_options.dart';
import 'package:app/services/hive_service.dart';
import 'package:app/utils/singletons.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Singletons.setup();

  await getIt<HiveService>().initBoxes();

  runApp(await builder());
}
