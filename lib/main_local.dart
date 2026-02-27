import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_environment.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      environment: PRFEnvironment.local,
      hiveBox: 'prf-super-app-${AppVersionHelper.getSluggedAppVersion()}',
      baseDomain: 'app.docker.orb.local',
      urlScheme: 'https',
      socketDomain: 'app.docker.orb.local',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 9000,
      azureConnString:
          'DefaultEndpointsProtocol=https;AccountName=prfcorestorage;AccountKey=oizfzMYG6gsjQWTfix8V/50Jh40qCg93DzNiFok/DxJjDOhffzM0TA4TNOV4TYqU1QONfaQOrrs7+ASteXMXPA==;EndpointSuffix=core.windows.net',
      appId: 'prf_missions_01khyfbrbnaqq8tjdcvjjnvv78',
      appSecret:
          'qeujrgcAc8NSmMof4IOcWzrTmOjSXEhUv6c2vKVARAaczzv9yOUoW2cK8UuEHLlb',
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) async => bootstrap(
      () => MultiBlocProvider(
        providers: DIContainer.registerCubits(),
        child: const PRFSuperApp(),
      ),
    ),
  );
}
