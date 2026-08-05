import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_environment.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      environment: PRFEnvironment.staging,
      hiveBox: 'prf-super-app-stg',
      baseDomain: 'stg-api.parkroadfellowship.org',
      urlScheme: 'https',
      azureConnString: '',
      appId: 'prf_missions_01khyfbrbnaqq8tjdcvjjnvv78',
      appSecret:
          'lXmRrcK3R1yJMs1r9iZ1omYdnHaUhJtdnwQO2Kz61mHH6T7SVC6ZyNShRKGcybOh',
      hiveEncryptionKey: 'random_stg',
      tenantUlid: '01kyvpa2pqkxjtvnwhdz9snwnw',
      socketDomain: 'hmt-ws.parkroadfellowship.org',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 443,
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
