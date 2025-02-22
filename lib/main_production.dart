import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      hiveBox: 'prf-super-app',
      baseDomain: 'api.parkroadfellowship.org',
      urlScheme: 'https',
      socketDomain: 'ws.parkroadfellowship.org',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'wss',
      socketPort: 443,
    ),
  );

  await bootstrap(
    () => MultiBlocProvider(
      providers: Singletons.registerCubits(),
      child: const PRFSuperApp(),
    ),
  );
}
