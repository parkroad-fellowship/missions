import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(MillerAdulu): Revert to production values
  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      hiveBox: 'prf-super-app-stg',
      baseDomain: 'dev.api.parkroadfellowship.org',
      urlScheme: 'https',
      socketDomain: 'dev.ws.parkroadfellowship.org',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 443,
      azureConnString:
          'DefaultEndpointsProtocol=https;AccountName=prfcorestorage;AccountKey=oizfzMYG6gsjQWTfix8V/50Jh40qCg93DzNiFok/DxJjDOhffzM0TA4TNOV4TYqU1QONfaQOrrs7+ASteXMXPA==;EndpointSuffix=core.windows.net',
    ),
  );

  // PRFSuperAppConfig(
  //   values: PRFSuperAppValues(
  //     hiveBox: 'prf-missions--${Misc.getSluggedAppVersion()}',
  //     baseDomain: 'api.parkroadfellowship.org',
  //     urlScheme: 'https',
  //     socketDomain: 'ws.parkroadfellowship.org',
  //     socketKey: 'yvnlkaqadqiadutrs9sa',
  //     socketScheme: 'wss',
  //     socketPort: 443,
  //     azureConnString:
  //         'DefaultEndpointsProtocol=https;AccountName=prfcorestorage;AccountKey=oizfzMYG6gsjQWTfix8V/50Jh40qCg93DzNiFok/DxJjDOhffzM0TA4TNOV4TYqU1QONfaQOrrs7+ASteXMXPA==;EndpointSuffix=core.windows.net',
  //   ),
  // );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async => bootstrap(
      () => MultiBlocProvider(
        providers: Singletons.registerCubits(),
        child: const PRFSuperApp(),
      ),
    ),
  );
}
