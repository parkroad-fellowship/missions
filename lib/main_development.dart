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
      environment: PRFEnvironment.development,
      hiveBox: 'prf-super-app-dev',
      baseDomain: 'dev-api.parkroadfellowship.org',
      urlScheme: 'https',
      socketDomain: 'dev-ws.parkroadfellowship.org',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 443,
      azureConnString: '',
      appId: 'prf_missions_01khyfbrbnaqq8tjdcvjjnvv78',
      appSecret:
          'GrGyVe1bkrkqKKlz0k0wh8KqgPnKjTDaQo9o7rDn9BkVr6iVORhVxS04wueOY5st',
      hiveEncryptionKey: 'random_dev',
      tenantUlid: '01kypvzr12zes0btzjh13fgfva',
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
