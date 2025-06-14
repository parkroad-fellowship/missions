import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      hiveBox: 'prf-super-app-stg',
      baseDomain: 'prf-missions.fly.dev',
      urlScheme: 'https',
      socketDomain: 'prf-missions.fly.dev',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 9000,
      azureConnString:
          'DefaultEndpointsProtocol=https;AccountName=prfcorestorage;AccountKey=oizfzMYG6gsjQWTfix8V/50Jh40qCg93DzNiFok/DxJjDOhffzM0TA4TNOV4TYqU1QONfaQOrrs7+ASteXMXPA==;EndpointSuffix=core.windows.net',
    ),
  );

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
