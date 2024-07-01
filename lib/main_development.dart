import 'package:app/app/app.dart';
import 'package:app/bootstrap.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PRFSuperAppConfig(
    values: PRFSuperAppValues(
      hiveBox: 'prf-super-app-dev-------',
      baseDomain: 'prf-sockets.test',
      urlScheme: 'http',
      socketKey: 'yvnlkaqadqiadutrs9sa',
      socketScheme: 'ws',
      socketPort: 8080,
    ),
  );

  Singletons.setup();
  await Singletons.setupDatabase();

  await bootstrap(
    () => MultiBlocProvider(
      providers: Singletons.registerCubits(),
      child: const PRFSuperApp(),
    ),
  );
}
